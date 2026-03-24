# Esto te interesa — Canal YouTube + Sitio Web

## Descripción
Canal de YouTube sobre tecnología, privacidad digital y criptomonedas.
Sitio web complementario con blog, videos y recursos.

## Stack del sitio web
- Framework: Astro (SSG) + React para componentes interactivos
- Estilos: Tailwind CSS
- Hosting: Vercel / Cloudflare Pages
- CMS: Archivos Markdown en /content
- Dominio: (por definir)

## Identidad del canal
- Nombre: "Esto te interesa"
- Tono: informativo pero accesible, como explicar tech a un amigo
- Idioma: español (España), anglicismos tech naturales
- Target: 18-35, interesados en tech pero no necesariamente técnicos
- Duración objetivo: 8-15 minutos por video

## Diseño del sitio
- Estética: moderna, limpia, dark mode por defecto
- Colores: fondo oscuro (#0a0a0a), acentos azul (#3b82f6) y verde (#22c55e)
- Tipografía: Inter (texto), JetBrains Mono (código)
- Inspiración: Fireship, Linus Tech Tips (web)

## Estructura del sitio
```
esto-te-interesa/
├── src/
│   ├── pages/
│   │   ├── index.astro        # Home: últimos videos + posts
│   │   ├── videos/            # Grid de videos
│   │   ├── blog/              # Artículos
│   │   ├── sobre-mi.astro     # Bio y links
│   │   └── contacto.astro     # Formulario
│   ├── components/
│   ├── layouts/
│   └── styles/
├── content/
│   ├── scripts/               # Scripts de videos (.md)
│   ├── blog/                  # Artículos del blog (.md)
│   └── videos.json            # Metadata de videos publicados
└── public/
    └── assets/
```

## Temáticas
- Privacidad digital (GrapheneOS, Tor, VPN)
- Criptomonedas (Bitcoin, XRP, DeFi)
- Tecnología emergente (IA, drones, automation)
- Seguridad informática
- Tutoriales técnicos accesibles

## SEO
- Title: máx 60 chars, keyword al inicio
- Description: máx 155 chars, incluir CTA
- og:image para cada página/artículo
- Sitemap automático (Astro lo genera)
- Schema.org VideoObject para videos
