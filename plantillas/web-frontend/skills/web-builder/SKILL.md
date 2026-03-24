---
name: web-builder
description: >
  Construye y modifica sitios web y aplicaciones frontend. Especializado
  en React, Astro, Next.js, HTML/CSS/JS, Tailwind CSS. Usa para crear
  componentes, páginas, layouts, o resolver problemas de frontend.
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Web Builder Skill

## Principios de diseño
- Mobile-first: diseñar para móvil primero, escalar hacia arriba
- Performance: lazy loading, code splitting, optimización de imágenes
- Accesibilidad: semántica HTML correcta, ARIA cuando sea necesario
- SEO: metadata completa, structured data, sitemap

## Stack preferido
- React + Vite para SPAs
- Astro para sitios con contenido estático (blogs, portfolios)
- Next.js si se necesita SSR/SSG con React
- Tailwind CSS para estilos (nunca CSS-in-JS)
- TypeScript siempre

## Workflow de implementación
1. Entender requisitos (qué, para quién, en qué dispositivos)
2. Crear estructura de archivos y componentes
3. Implementar layout responsive (mobile → tablet → desktop)
4. Añadir interactividad y estado
5. Optimizar performance (bundle size, lazy loading)
6. Verificar accesibilidad (axe-core o similar)
7. Verificar en múltiples viewports

## Patrones de componentes React
```tsx
// Componente con props tipadas
interface CardProps {
  title: string;
  description: string;
  image?: string;
  onClick?: () => void;
}

export function Card({ title, description, image, onClick }: CardProps) {
  return (
    <div 
      className="rounded-lg border p-4 hover:shadow-md transition-shadow"
      onClick={onClick}
      role={onClick ? "button" : undefined}
      tabIndex={onClick ? 0 : undefined}
    >
      {image && <img src={image} alt={title} className="w-full rounded-md mb-3" />}
      <h3 className="font-semibold text-lg">{title}</h3>
      <p className="text-gray-600 mt-1">{description}</p>
    </div>
  );
}
```

## Anti-patrones a evitar
- `any` en TypeScript
- Inline styles (usar Tailwind)
- Componentes >150 líneas (descomponer)
- useEffect para lógica que debería estar en event handlers
- Imágenes sin dimensiones (causan layout shift)
- Divs donde deberían ir elementos semánticos (nav, main, section, article)
