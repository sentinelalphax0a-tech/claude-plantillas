---
name: fullstack-api
description: >
  Diseño e implementación de backend y API. Usa cuando se creen API routes,
  server actions, esquemas de base de datos, middleware, autenticación,
  o cualquier lógica de servidor. Cubre Next.js Route Handlers, Server
  Actions, Supabase, Prisma/Drizzle, y patrones de API.
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Fullstack API Skill

## API Routes (Next.js Route Handlers)

### Estructura estándar
```ts
// src/app/api/[recurso]/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { createServerClient } from '@/lib/supabase/server';
import { createResourceSchema } from '@/lib/validations/resource';

// GET /api/resources
export async function GET(req: NextRequest) {
  const supabase = await createServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: 'No auth' }, { status: 401 });

  const { searchParams } = req.nextUrl;
  const page = parseInt(searchParams.get('page') ?? '1');
  const limit = Math.min(parseInt(searchParams.get('limit') ?? '20'), 100);

  const { data, count } = await supabase
    .from('resources')
    .select('*', { count: 'exact' })
    .eq('user_id', user.id)
    .range((page - 1) * limit, page * limit - 1)
    .order('created_at', { ascending: false });

  return NextResponse.json({
    data,
    pagination: { page, limit, total: count },
  });
}

// POST /api/resources
export async function POST(req: NextRequest) {
  const supabase = await createServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: 'No auth' }, { status: 401 });

  const body = await req.json();
  const parsed = createResourceSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ errors: parsed.error.flatten() }, { status: 400 });
  }

  const { data, error } = await supabase
    .from('resources')
    .insert({ ...parsed.data, user_id: user.id })
    .select()
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json(data, { status: 201 });
}
```

## Server Actions (para mutaciones desde formularios)

```ts
// src/app/actions/project.ts
"use server";

import { revalidatePath } from 'next/cache';
import { createServerClient } from '@/lib/supabase/server';
import { createProjectSchema } from '@/lib/validations/project';

export async function createProject(formData: FormData) {
  const supabase = await createServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('No autenticado');

  const parsed = createProjectSchema.safeParse({
    name: formData.get('name'),
    description: formData.get('description'),
  });
  if (!parsed.success) return { errors: parsed.error.flatten().fieldErrors };

  const { error } = await supabase
    .from('projects')
    .insert({ ...parsed.data, user_id: user.id });

  if (error) return { errors: { _form: [error.message] } };

  revalidatePath('/dashboard');
  return { success: true };
}
```

## Supabase Client Setup

```ts
// src/lib/supabase/server.ts — Para Server Components y API Routes
import { createServerClient as create } from '@supabase/ssr';
import { cookies } from 'next/headers';

export async function createServerClient() {
  const cookieStore = await cookies();
  return create(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => cookieStore.getAll(),
        setAll: (cookies) => {
          cookies.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          );
        },
      },
    }
  );
}

// src/lib/supabase/admin.ts — Para webhooks y operaciones admin (bypasea RLS)
import { createClient } from '@supabase/supabase-js';

export function createServiceClient() {
  return createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!, // NUNCA en NEXT_PUBLIC_
  );
}

// src/lib/supabase/client.ts — Para Client Components
import { createBrowserClient } from '@supabase/ssr';

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
```

## Esquema de base de datos (patrón típico SaaS)

```sql
-- Tabla de perfiles (extiende auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  avatar_url TEXT,
  stripe_customer_id TEXT UNIQUE,
  subscription_status TEXT DEFAULT 'free',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Trigger para crear perfil automáticamente al registrarse
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
```

## Patrones de error handling

```ts
// src/lib/errors.ts
export class AppError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public code?: string
  ) {
    super(message);
  }
}

// Wrapper para API routes
export function withErrorHandler(
  handler: (req: NextRequest) => Promise<NextResponse>
) {
  return async (req: NextRequest) => {
    try {
      return await handler(req);
    } catch (error) {
      if (error instanceof AppError) {
        return NextResponse.json(
          { error: error.message, code: error.code },
          { status: error.statusCode }
        );
      }
      console.error('Unhandled error:', error);
      return NextResponse.json(
        { error: 'Error interno del servidor' },
        { status: 500 }
      );
    }
  };
}
```
