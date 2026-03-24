# Web Pro Template — Plantilla Fullstack de Calidad Profesional

Stack: **Next.js 15 · TypeScript · Tailwind · Supabase · Stripe**

---

## Qué incluye

### 9 Skills (se activan automáticamente por contexto)

| Skill | Cuándo se activa | Para qué |
|-------|-----------------|----------|
| **design-system** | Al tocar cualquier componente UI | Sistema de diseño anti-genérico. Tipografía, color, animaciones, micro-interacciones. |
| **web-builder** | Al implementar componentes/páginas | Patrones Next.js 15, Server/Client Components, formularios, estado. |
| **mobile-design** | Al trabajar en UI (siempre con design-system) | Touch targets 44px, safe areas, inputs sin zoom, scroll, dark mode. |
| **stripe-payments** | Al tocar código de pagos | Checkout, subscriptions, webhooks, customer portal. Con código listo. |
| **security-hardening** | Al tocar auth, middleware, API routes | Headers, RLS, rate limiting, validación. Capa defensiva. |
| **cybersecurity-pentest** | Al escribir API routes, formularios, uploads | Inyecciones SQL/XSS/Command, autenticación, CORS, uploads seguros. |
| **performance-audit** | Al optimizar o pre-deploy | Core Web Vitals, imágenes, fonts, bundle size. Checklist pre-launch. |
| **seo-optimizer** | Al trabajar en páginas públicas | Meta tags, Schema.org, sitemap, Open Graph, headings. |
| **fullstack-api** | Al diseñar backend | API routes, Server Actions, Supabase, esquemas DB, error handling. |

---

### 7 Agentes (se invocan manualmente)

| Agente | Herramientas | Rol | Cuándo usarlo |
|--------|-------------|-----|---------------|
| **frontend-architect** | Read, Grep, Glob | Planifica componentes, estado, loading states. | Antes de implementar una feature frontend. |
| **backend-architect** | Read, Grep, Glob | Diseña schemas, API, flujos de datos. | Antes de implementar lógica de servidor. |
| **ui-designer** | Read, Grep, Glob | Detecta diseño genérico, propone mejoras visuales. | Antes de considerar una página "terminada". |
| **security-auditor** | Read, Grep, Glob, Bash | Auditoría rápida: auth, RLS, secretos, headers. | Antes de cada deploy. |
| **qa-tester** | Read, Grep, Glob, Bash | Verifica rutas, links, botones, forms, imágenes, loading/error states. | Antes de deploy y tras features grandes. |
| **mobile-reviewer** | Read, Grep, Glob | Puntuación mobile 1-10 + lista de problemas por impacto. | Tras implementar cualquier UI nueva. |
| **security-pentester** | Read, Grep, Glob, Bash | Pentest: keys expuestas, SQLi, XSS, auth bypass, Stripe, RLS. | Antes de launch y auditorías periódicas. |

---

### MCP Servers por tipo de proyecto

| MCP | Tipo de web | Setup |
|-----|------------|-------|
| **Context7** | Todas | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest` |
| **Playwright** | Todas | `claude mcp add playwright -- npx -y @anthropic-ai/mcp-server-playwright` |
| **GitHub** | Todas | `claude mcp add --transport http github https://api.githubcopilot.com/mcp/` |
| **Supabase** | Con auth/DB | `claude mcp add --transport http supabase "https://mcp.supabase.com/mcp?project_ref=REF"` |
| **PostgreSQL** | Con DB propia | `claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres DATABASE_URL` |
| **Stripe** | Con pagos | `claude mcp add --transport http stripe https://mcp.stripe.com` |
| **PayPal** | Con pagos | `claude mcp add --transport http paypal https://mcp.paypal.com/mcp` |
| **Shopify Dev** | E-commerce | `claude mcp add shopify-dev -- npx -y @anthropic-ai/shopify-dev-mcp@latest` |
| **Shopify Admin** | E-commerce | `claude mcp add shopify -- npx shopify-mcp --accessToken TOKEN --domain SHOP.myshopify.com` |
| **Notion** | Con CMS | `claude mcp add --transport http notion https://mcp.notion.com/mcp` |
| **Sentry** | Producción | `claude mcp add --transport http sentry https://mcp.sentry.dev/mcp` |

Ver `.mcp.json` para configuración completa con comentarios.

---

### Hooks automáticos

| Hook | Trigger | Acción |
|------|---------|--------|
| **PostToolUse** | Editar `.ts`, `.tsx`, `.js` | Auto-prettier + auto-eslint |
| **PostToolUse** | Editar `*.test.ts` | Auto-run tests del archivo |
| **PreToolUse** | Bash con `rm -rf`, `DROP TABLE` | Bloquea y pide confirmación |
| **Stop** | Claude termina su respuesta | Notificación de escritorio |

---

## Workflow recomendado

```
1. PLANIFICAR
   > Usa el frontend-architect para planificar [feature]
   > Usa el backend-architect para diseñar la API de [feature]

2. IMPLEMENTAR (skills se activan solas)
   > Implementa [feature] según el plan
   — design-system + web-builder + mobile-design se activan en UI
   — fullstack-api + security-hardening se activan en backend
   — cybersecurity-pentest se activa en API routes y formularios

3. REVISAR DISEÑO Y MOBILE
   > Usa el ui-designer para revisar la página de [feature]
   > Usa el mobile-reviewer para auditar la experiencia móvil

4. TESTEAR FUNCIONALIDAD
   > Usa el qa-tester para verificar toda la funcionalidad

5. AUDITAR SEGURIDAD
   > Usa el security-pentester para hacer pentest completo
   > Usa el security-auditor para verificación rápida pre-deploy

6. OPTIMIZAR
   > Audita el rendimiento (performance-audit se activa)
   > Revisa el SEO de [página] (seo-optimizer se activa)
```

---

## Setup rápido

Ver `GUIA-SETUP.md` para instrucciones completas.

### Checklist express (ya tienes la plantilla en `~/plantillas/web-pro/`)

```bash
# 1. Crear proyecto Next.js
npx create-next-app@latest mi-proyecto --typescript --tailwind --eslint --app --src-dir
cd mi-proyecto

# 2. Copiar plantilla
mkdir -p .claude/{skills,agents,hooks}
cp -r ~/plantillas/web-pro/skills/* .claude/skills/
cp -r ~/plantillas/web-pro/agents/* .claude/agents/
cp ~/plantillas/web-pro/hooks/settings.json .claude/settings.json
cp ~/plantillas/web-pro/.mcp.json .mcp.json
cp ~/plantillas/web-pro/CLAUDE.md.template CLAUDE.md

# 3. MCP mínimos (siempre)
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
claude mcp add playwright -- npx -y @anthropic-ai/mcp-server-playwright
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 4. MCP según tipo (elige los que aplican)
# Con Supabase:
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp?project_ref=TU_REF"
# Con Stripe:
claude mcp add --transport http stripe https://mcp.stripe.com
# Con Shopify:
claude mcp add shopify-dev -- npx -y @anthropic-ai/shopify-dev-mcp@latest

# 5. Editar CLAUDE.md con los datos del proyecto
# 6. Lanzar
claude
```

---

## Filosofía

Esta plantilla existe para que cada proyecto web tenga:

- **Diseño con personalidad** — no genérico de IA, con sistema visual propio
- **Mobile-first real** — touch targets, safe areas, sin zoom, sin overflow
- **Seguridad desde el día 1** — no "ya lo haré después"
- **Pentest incluido** — dos capas: hardening defensivo + pentest ofensivo
- **QA sistemático** — no asumir que algo funciona, verificarlo
- **Performance real** — Core Web Vitals en verde, no solo "pasa el Lighthouse"
- **Pagos que funcionan** — Stripe bien integrado con webhooks verificados
- **Backend sólido** — Supabase + RLS + validación Zod
- **SEO correcto** — no perfecto, pero correcto desde el inicio
