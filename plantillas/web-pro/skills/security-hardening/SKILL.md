---
name: security-hardening
description: >
  Seguridad web. Usa cuando se cree o revise autenticación, autorización,
  formularios, API routes, headers HTTP, manejo de datos sensibles,
  variables de entorno, o cualquier aspecto de seguridad. También para
  auditorías de seguridad y hardening previo a deploy.
context: fork
allowed-tools: Read, Grep, Glob, Bash
---

# Security Hardening Skill

## Headers de seguridad (next.config.ts)

```ts
// next.config.ts
const securityHeaders = [
  { key: 'X-DNS-Prefetch-Control', value: 'on' },
  { key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' },
  { key: 'X-Frame-Options', value: 'SAMEORIGIN' },
  { key: 'X-Content-Type-Options', value: 'nosniff' },
  { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
  { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=()' },
  {
    key: 'Content-Security-Policy',
    value: [
      "default-src 'self'",
      "script-src 'self' 'unsafe-eval' 'unsafe-inline' js.stripe.com",
      "style-src 'self' 'unsafe-inline'",
      "img-src 'self' data: blob: *.supabase.co",
      "connect-src 'self' *.supabase.co api.stripe.com",
      "frame-src js.stripe.com",
      "font-src 'self'",
    ].join('; '),
  },
];

export default {
  async headers() {
    return [{ source: '/(.*)', headers: securityHeaders }];
  },
};
```

## Autenticación (patrones seguros)

### Middleware de autenticación (Next.js)
```ts
// src/middleware.ts
import { NextRequest, NextResponse } from 'next/server';
import { createServerClient } from '@supabase/ssr';

const protectedPaths = ['/dashboard', '/billing', '/settings'];
const authPaths = ['/login', '/register'];

export async function middleware(req: NextRequest) {
  const res = NextResponse.next();
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    { cookies: { /* cookie handlers */ } }
  );

  const { data: { user } } = await supabase.auth.getUser();
  const isProtected = protectedPaths.some(p => req.nextUrl.pathname.startsWith(p));
  const isAuth = authPaths.some(p => req.nextUrl.pathname.startsWith(p));

  // No autenticado intentando acceder a ruta protegida
  if (!user && isProtected) {
    return NextResponse.redirect(new URL('/login', req.url));
  }
  // Autenticado intentando acceder a login/register
  if (user && isAuth) {
    return NextResponse.redirect(new URL('/dashboard', req.url));
  }

  return res;
}
```

### Supabase RLS (Row Level Security) — OBLIGATORIO
```sql
-- SIEMPRE activar RLS en cada tabla
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Política: usuarios solo ven sus propios proyectos
CREATE POLICY "Users can view own projects"
  ON projects FOR SELECT
  USING (auth.uid() = user_id);

-- Política: usuarios solo insertan con su propio user_id
CREATE POLICY "Users can create own projects"
  ON projects FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Política: usuarios solo editan sus proyectos
CREATE POLICY "Users can update own projects"
  ON projects FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- NUNCA crear una política que permita todo:
-- ❌ CREATE POLICY "Allow all" ON projects FOR ALL USING (true);
```

## Validación de inputs (DOBLE: cliente + servidor)

```ts
// src/lib/validations/project.ts — Schema Zod compartido
import { z } from 'zod';

export const createProjectSchema = z.object({
  name: z.string()
    .min(2, 'Mínimo 2 caracteres')
    .max(100, 'Máximo 100 caracteres')
    .regex(/^[a-zA-Z0-9\s\-_áéíóúñ]+$/, 'Caracteres no permitidos'),
  description: z.string().max(500).optional(),
  isPublic: z.boolean().default(false),
});

// USAR en el cliente (React Hook Form) Y en el servidor (API route)
// src/app/api/projects/route.ts
export async function POST(req: NextRequest) {
  const body = await req.json();
  const parsed = createProjectSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ errors: parsed.error.flatten() }, { status: 400 });
  }
  // ...usar parsed.data (tipado y sanitizado)
}
```

## Rate limiting
```ts
// src/lib/rate-limit.ts
const rateLimit = new Map<string, { count: number; resetAt: number }>();

export function checkRateLimit(
  key: string,
  limit: number = 10,
  windowMs: number = 60_000
): boolean {
  const now = Date.now();
  const entry = rateLimit.get(key);
  if (!entry || now > entry.resetAt) {
    rateLimit.set(key, { count: 1, resetAt: now + windowMs });
    return true;
  }
  if (entry.count >= limit) return false;
  entry.count++;
  return true;
}

// Uso en API route:
const ip = req.headers.get('x-forwarded-for') ?? 'unknown';
if (!checkRateLimit(`api:${ip}`, 20, 60_000)) {
  return NextResponse.json({ error: 'Too many requests' }, { status: 429 });
}
```

## Checklist de auditoría de seguridad

### Variables de entorno
- [ ] Ningún secreto en NEXT_PUBLIC_ (excepto Supabase anon key y Stripe publishable)
- [ ] .env.local en .gitignore
- [ ] Secretos en Vercel Environment Variables (no en código)

### Autenticación y autorización
- [ ] Middleware protege todas las rutas privadas
- [ ] RLS activado en TODAS las tablas de Supabase
- [ ] getUser() verificado en cada API route protegida
- [ ] Tokens con expiración razonable

### Inputs y datos
- [ ] Validación Zod en cliente Y servidor
- [ ] No SQL raw sin parametrizar
- [ ] Uploads limitados en tamaño y tipo MIME
- [ ] Sanitización de HTML si se renderiza contenido de usuario

### Headers y transporte
- [ ] HTTPS obligatorio (HSTS)
- [ ] CSP configurada
- [ ] Cookies: httpOnly, secure, sameSite
- [ ] CORS restringido al dominio propio

### Stripe (si aplica)
- [ ] Webhook signature verificada
- [ ] Secret key solo en servidor
- [ ] No se confía en datos del cliente para pagos
