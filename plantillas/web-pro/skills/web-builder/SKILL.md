---
name: web-builder
description: >
  Construye componentes, páginas y layouts para aplicaciones web fullstack.
  Usa para implementar features, crear componentes React/Next.js, layouts
  responsive, y conectar frontend con backend. Siempre consulta la skill
  design-system para decisiones visuales.
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Web Builder Skill

## Antes de escribir código

1. Lee CLAUDE.md del proyecto (identidad visual, stack, convenciones)
2. Revisa si ya existe un componente similar en src/components/
3. Si es UI puro → consultar skill design-system
4. Si toca datos → consultar skill fullstack-api
5. Si toca pagos → consultar skill stripe-payments

## Patrones de componentes Next.js 15

### Server Components (por defecto)
```tsx
// src/app/(app)/dashboard/page.tsx
// Server Component — accede a DB directamente, no necesita "use client"
import { createServerClient } from '@/lib/supabase/server';
import { DashboardShell } from '@/components/dashboard/shell';

export default async function DashboardPage() {
  const supabase = await createServerClient();
  const { data: projects } = await supabase
    .from('projects')
    .select('*')
    .order('updated_at', { ascending: false });

  return <DashboardShell projects={projects ?? []} />;
}
```

### Client Components (solo cuando hay interactividad)
```tsx
// src/components/dashboard/project-card.tsx
"use client";

import { motion } from "framer-motion";
import { formatDistanceToNow } from "date-fns";
import { es } from "date-fns/locale";

interface ProjectCardProps {
  project: Project;
  onSelect: (id: string) => void;
}

export function ProjectCard({ project, onSelect }: ProjectCardProps) {
  return (
    <motion.button
      onClick={() => onSelect(project.id)}
      whileHover={{ y: -2 }}
      whileTap={{ scale: 0.98 }}
      className="group text-left w-full rounded-xl border p-5
        hover:border-primary/30 hover:shadow-lg
        transition-[border-color,box-shadow] duration-300"
    >
      {/* Contenido */}
    </motion.button>
  );
}
```

### Regla: minimizar "use client"
- Server Components: fetch de datos, layouts, páginas estáticas
- Client Components: formularios, modales, dropdowns, animaciones
- Mover el "use client" lo más abajo posible en el árbol

## Estructura de features

Cada feature grande tiene su propia carpeta:
```
src/
├── components/
│   └── billing/           # Feature: billing
│       ├── pricing-table.tsx    # Client — interactivo
│       ├── plan-badge.tsx       # Server — estático
│       ├── upgrade-modal.tsx    # Client — modal
│       └── index.ts             # Re-exports
├── app/(app)/
│   └── billing/
│       ├── page.tsx             # Server — data fetch
│       └── loading.tsx          # Skeleton loading
└── lib/
    └── stripe/
        └── plans.ts             # Datos de planes
```

## Formularios (patrón estándar)

```tsx
"use client";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { createProjectSchema, type CreateProject } from "@/lib/validations/project";

export function CreateProjectForm() {
  const form = useForm<CreateProject>({
    resolver: zodResolver(createProjectSchema),
    defaultValues: { name: "", description: "" },
  });

  const onSubmit = async (data: CreateProject) => {
    // Server action o fetch a API route
  };

  return (
    <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
      {/* Campos con react-hook-form + validación visual */}
    </form>
  );
}
```

## Loading states (OBLIGATORIO)

Cada page.tsx necesita un loading.tsx con skeleton:
```tsx
// src/app/(app)/dashboard/loading.tsx
export default function DashboardLoading() {
  return (
    <div className="space-y-6 p-6">
      <div className="h-8 w-48 rounded-lg bg-muted animate-pulse" />
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {[...Array(6)].map((_, i) => (
          <div key={i} className="h-32 rounded-xl bg-muted animate-pulse" />
        ))}
      </div>
    </div>
  );
}
```

## Error handling (OBLIGATORIO)

Cada route group necesita un error.tsx:
```tsx
"use client";
export default function DashboardError({ error, reset }: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="flex flex-col items-center justify-center min-h-[50vh] gap-4">
      <h2 className="text-xl font-semibold">Algo salió mal</h2>
      <p className="text-muted-foreground">{error.message}</p>
      <button onClick={reset} className="...">Reintentar</button>
    </div>
  );
}
```

## Anti-patrones
- `any` en TypeScript → usar tipos estrictos siempre
- Inline styles → usar Tailwind
- Fetch en useEffect → usar Server Components o React Query
- console.log en producción → usar logger condicional
- Componentes >150 líneas → descomponer
- Importar librería completa → import selectivo (tree-shaking)
