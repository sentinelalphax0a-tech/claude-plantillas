---
name: seo-optimizer
description: >
  Optimización SEO técnico y de contenido. Usa para auditar meta tags,
  headings, Open Graph, Schema.org, sitemap, robots.txt, performance
  SEO, y optimización de contenido para buscadores.
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob
---

# SEO Optimizer Skill

## Meta tags (por página — en Next.js)

```tsx
// src/app/(marketing)/page.tsx
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Mi App — Tagline que incluye keyword',  // <60 chars
  description: 'Descripción clara con keyword principal y CTA. Máximo 155 caracteres.',
  openGraph: {
    title: 'Mi App — Tagline',
    description: 'Descripción para redes sociales',
    url: 'https://miapp.com',
    siteName: 'Mi App',
    images: [{ url: '/og/home.png', width: 1200, height: 630 }],
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Mi App — Tagline',
    description: 'Descripción para Twitter',
    images: ['/og/home.png'],
  },
  alternates: { canonical: 'https://miapp.com' },
  robots: { index: true, follow: true },
};
```

## Schema.org (JSON-LD)

```tsx
// src/components/seo/json-ld.tsx
export function WebsiteJsonLd() {
  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{
        __html: JSON.stringify({
          "@context": "https://schema.org",
          "@type": "WebApplication",
          name: "Mi App",
          url: "https://miapp.com",
          description: "...",
          applicationCategory: "BusinessApplication",
          offers: {
            "@type": "Offer",
            price: "0",
            priceCurrency: "EUR",
          },
        }),
      }}
    />
  );
}
```

## Checklist de auditoría SEO

### Por página
- [ ] `<title>` único, <60 chars, keyword al inicio
- [ ] `<meta description>` única, <155 chars, CTA incluido
- [ ] Open Graph completo (title, description, image 1200x630)
- [ ] Un solo `<h1>` con keyword principal
- [ ] Jerarquía H1 > H2 > H3 (sin saltar niveles)
- [ ] Alt text en todas las imágenes
- [ ] URLs limpias y descriptivas (no /page?id=123)
- [ ] Canonical URL definida

### Técnico (global)
- [ ] sitemap.xml generado y enviado a Google Search Console
- [ ] robots.txt configurado
- [ ] Schema.org markup (Organization, WebApplication, FAQ)
- [ ] Core Web Vitals en verde
- [ ] HTTPS obligatorio
- [ ] Idioma declarado: `<html lang="es">`
- [ ] Favicon y apple-touch-icon

### Contenido
- [ ] Contenido único por página
- [ ] Internal links entre páginas relacionadas
- [ ] Anchor text descriptivo (no "click aquí")
- [ ] No keyword stuffing
