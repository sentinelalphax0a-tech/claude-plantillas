---
name: seo-optimizer
description: >
  Analiza y optimiza el SEO de páginas web. Usa cuando el usuario pida
  mejorar SEO, revisar meta tags, analizar estructura de headings,
  o preparar contenido para buscadores.
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob
---

# SEO Optimizer Skill

## Checklist de auditoría SEO

### Meta tags (por página)
- `<title>` — máx 60 caracteres, keyword principal al inicio
- `<meta name="description">` — máx 155 caracteres, incluir CTA
- `<meta property="og:title">` + `og:description` + `og:image`
- `<meta name="robots">` — apropiado para la página
- `<link rel="canonical">` — evitar duplicados

### Estructura de contenido
- Un solo `<h1>` por página con keyword principal
- Jerarquía correcta: H1 > H2 > H3 (sin saltar niveles)
- Alt text descriptivo en todas las imágenes
- Links internos con anchor text descriptivo

### Técnico
- Sitemap.xml generado y actualizado
- robots.txt configurado
- Schema.org markup (Article, Product, FAQ según el caso)
- Velocidad de carga (Core Web Vitals)
- Mobile-friendly (responsive)
- HTTPS obligatorio

### Contenido
- Densidad de keywords natural (no keyword stuffing)
- URLs limpias y descriptivas (no `/page?id=123`)
- Contenido único (no duplicado entre páginas)

## Formato de reporte
```
## Auditoría SEO — [página/sitio]

### ✅ Correcto
- [lo que está bien]

### ⚠️ Mejorar
- [problema] → [solución concreta]

### ❌ Crítico
- [problema grave] → [solución]

### Puntuación estimada: X/10
```
