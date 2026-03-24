---
name: performance-audit
description: >
  Optimización de rendimiento web. Usa para auditar Core Web Vitals,
  reducir bundle size, optimizar imágenes, mejorar tiempos de carga,
  lazy loading, code splitting, o cualquier problema de performance.
  También para preparar un sitio antes de lanzamiento.
context: fork
allowed-tools: Read, Grep, Glob, Bash
---

# Performance Audit Skill

## Core Web Vitals — Objetivos

| Métrica | Bueno | Necesita mejora | Malo |
|---------|-------|-----------------|------|
| LCP (Largest Contentful Paint) | <2.5s | 2.5-4s | >4s |
| INP (Interaction to Next Paint) | <200ms | 200-500ms | >500ms |
| CLS (Cumulative Layout Shift) | <0.1 | 0.1-0.25 | >0.25 |

## Imágenes (mayor impacto en LCP)

```tsx
// SIEMPRE usar next/image — optimiza automáticamente
import Image from 'next/image';

// ✅ Con dimensiones (evita CLS)
<Image
  src="/hero.jpg"
  width={1200}
  height={630}
  alt="Descripción"
  priority          // Solo para above-the-fold (LCP)
  placeholder="blur" // Blur placeholder mientras carga
  blurDataURL="..."  // Base64 tiny (generar con plaiceholder)
/>

// ✅ Responsive con sizes (reduce payload)
<Image
  src="/product.jpg"
  fill
  sizes="(max-width: 768px) 100vw, (max-width: 1024px) 50vw, 33vw"
  alt="Producto"
  className="object-cover"
/>
```

### Formatos
- WebP para fotos (30% menos que JPEG)
- AVIF si el browser lo soporta (50% menos que JPEG)
- SVG para iconos y logos (siempre)
- next/image hace conversión automática

## Fonts (segundo mayor impacto)

```tsx
// ✅ Fonts locales (más rápido que Google Fonts)
// next.config.ts ya no necesita configuración especial

// src/app/layout.tsx
import localFont from 'next/font/local';

const satoshi = localFont({
  src: '../public/fonts/Satoshi-Variable.woff2',
  variable: '--font-satoshi',
  display: 'swap',     // CRÍTICO: evita flash of invisible text
  preload: true,
});
```

## Bundle size

```bash
# Analizar qué ocupa espacio
npx @next/bundle-analyzer

# Verificar tamaño de imports
npx import-cost   # En VS Code como extensión
```

### Patrones de reducción
```tsx
// ❌ Importar toda la librería
import { format, formatDistance, isAfter, isBefore } from 'date-fns';

// ✅ Solo lo que usas (tree-shaking)
import format from 'date-fns/format';
import { es } from 'date-fns/locale/es';

// ❌ Cargar componente pesado inmediatamente
import { HeavyChart } from '@/components/chart';

// ✅ Lazy load con Suspense
import dynamic from 'next/dynamic';
const HeavyChart = dynamic(() => import('@/components/chart'), {
  loading: () => <div className="h-64 animate-pulse bg-muted rounded-xl" />,
  ssr: false,  // Si no necesita SSR
});
```

## Carga progresiva y skeletons

```tsx
// Streaming con Suspense (Next.js App Router)
import { Suspense } from 'react';

export default function DashboardPage() {
  return (
    <div>
      <h1>Dashboard</h1>
      {/* Esto carga instantáneamente */}
      <QuickStats />
      
      {/* Esto se streama cuando esté listo */}
      <Suspense fallback={<ChartSkeleton />}>
        <RevenueChart />
      </Suspense>
      
      <Suspense fallback={<TableSkeleton rows={5} />}>
        <RecentTransactions />
      </Suspense>
    </div>
  );
}
```

## Checklist pre-lanzamiento

### Imágenes
- [ ] Todas las imágenes usan next/image
- [ ] Imágenes above-the-fold tienen priority
- [ ] Todas tienen alt text y dimensiones
- [ ] No hay imágenes >200KB sin optimizar

### Código
- [ ] No hay imports innecesarios (tree-shaking)
- [ ] Componentes pesados tienen lazy loading
- [ ] Bundle total <200KB (first load JS)
- [ ] No console.log en producción

### Fonts
- [ ] Fonts locales (no CDN)
- [ ] font-display: swap
- [ ] Solo los pesos que se usan (no variable completa si solo usas 2)

### Datos
- [ ] Server Components para fetch estático
- [ ] React Query con staleTime para datos dinámicos
- [ ] Paginación en listas largas (no cargar 1000 items)
- [ ] Índices en DB para queries frecuentes

### Infra
- [ ] Vercel Edge: middleware ligero (<1MB)
- [ ] Caching headers correctos (stale-while-revalidate)
- [ ] CDN para assets estáticos
