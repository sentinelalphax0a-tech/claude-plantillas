# Web Pro Template — Plantilla Fullstack de Calidad Profesional

## Qué incluye

### 7 Skills
| Skill | Para qué |
|-------|----------|
| **design-system** | Sistema de diseño anti-IA. Tipografía, color, animaciones, micro-interacciones. Se carga SIEMPRE que toques UI. |
| **web-builder** | Implementación de componentes y páginas. Patrones Next.js 15, Server/Client Components, formularios. |
| **stripe-payments** | Integración completa de Stripe: Checkout, subscriptions, webhooks, customer portal. Con código listo. |
| **security-hardening** | Seguridad web: headers, RLS, validación, rate limiting, middleware auth. Con checklists. |
| **performance-audit** | Core Web Vitals, imágenes, fonts, bundle size, lazy loading. Checklist pre-launch. |
| **seo-optimizer** | SEO técnico: meta tags, Schema.org, sitemap, headings, Open Graph. |
| **fullstack-api** | Backend: API routes, Server Actions, Supabase setup, esquemas DB, error handling. |

### 4 Agentes
| Agente | Rol | Cuándo usarlo |
|--------|-----|---------------|
| **ui-designer** | Revisor visual. Detecta diseño genérico y propone mejoras concretas. | Antes de considerar una página "terminada". |
| **security-auditor** | Auditor de seguridad. Busca vulnerabilidades. | Antes de cada deploy y en PRs importantes. |
| **frontend-architect** | Planifica componentes, estado, loading states. | Antes de implementar una feature frontend nueva. |
| **backend-architect** | Diseña schemas, API, flujos de datos. | Antes de implementar lógica de servidor nueva. |

### 5 MCP Servers
| MCP | Para qué | Setup |
|-----|----------|-------|
| **Context7** | Docs actualizadas de cualquier librería. Evita código deprecated. | `claude mcp add context7 -- npx -y @upstash/context7-mcp@latest` |
| **Playwright** | Testing E2E y verificación visual. | `claude mcp add playwright -- npx -y @anthropic-ai/mcp-server-playwright` |
| **Supabase** | Acceso directo a DB, auth, storage. | `claude mcp add --transport http supabase https://mcp.supabase.com/mcp?project_ref=TU_REF` |
| **GitHub** | Gestión de repo, PRs, issues. | `claude mcp add --transport http github https://api.githubcopilot.com/mcp/` |
| **Stripe** | Crear productos, precios, checkout, webhooks. | `claude mcp add --transport http stripe https://mcp.stripe.com` |

### Hooks automáticos
- **PostToolUse**: auto-prettier + auto-eslint en cada archivo TS/JS editado
- **PostToolUse**: auto-test si editas un archivo `*.test.ts`
- **PreToolUse**: bloquea `rm -rf`, `DROP TABLE`, etc
- **Stop**: notificación de escritorio al terminar

## Cómo usar

### Proyecto nuevo
```bash
# 1. Crear proyecto
npx create-next-app@latest mi-proyecto --typescript --tailwind --eslint --app
cd mi-proyecto

# 2. Copiar template
mkdir -p .claude/{skills,agents}
cp -r /ruta/a/web-pro/skills/* .claude/skills/
cp -r /ruta/a/web-pro/agents/* .claude/agents/
cp /ruta/a/web-pro/hooks/settings.json .claude/settings.json
cp /ruta/a/web-pro/.mcp.json .mcp.json
cp /ruta/a/web-pro/CLAUDE.md.template CLAUDE.md

# 3. Editar CLAUDE.md con los datos del proyecto
# 4. Configurar MCP servers (ejecutar los comandos de arriba)
# 5. Lanzar Claude Code
claude
```

### Workflow recomendado por feature
```
1. Planifica (agente)
   > Usa el frontend-architect para planificar [feature]
   > Usa el backend-architect para diseñar la API de [feature]

2. Implementa (skills se activan solas)
   > Implementa [feature] según el plan
   (design-system + web-builder + fullstack-api se activan por contexto)

3. Revisa (agentes)
   > Usa el ui-designer para revisar la página de [feature]
   > Usa el security-auditor para auditar [feature]

4. Optimiza (skills)
   > Audita el rendimiento de [feature] (performance-audit se activa)
   > Revisa el SEO de [página] (seo-optimizer se activa)
```

## Filosofía

Esta plantilla existe para que cada proyecto web que hagas tenga:
- **Diseño con personalidad** (no genérico de IA)
- **Seguridad desde el día 1** (no "ya lo haré después")
- **Performance real** (Core Web Vitals en verde)
- **Pagos que funcionan** (Stripe bien integrado)
- **Backend sólido** (Supabase + RLS + validación)
- **SEO correcto** (no perfecto, pero correcto desde el inicio)
