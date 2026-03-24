# Guía: Cómo Arrancar un Proyecto Web Nuevo con el Template

> Guarda este archivo junto a tu carpeta `web-pro/`.
> Cada vez que quieras hacer una web nueva, sigue estos pasos en orden.

---

## Requisitos previos (solo la primera vez)

Necesitas tener instalado:

```bash
# Node.js v20+ (comprueba con)
node --version

# npm (viene con Node.js)
npm --version

# Claude Code
npm install -g @anthropic-ai/claude-code
claude --version

# Git
git --version

# Stripe CLI (solo si el proyecto tiene pagos)
# https://docs.stripe.com/stripe-cli
stripe --version
```

Y tu carpeta `web-pro/` guardada en algún sitio fijo, por ejemplo:
```
~/plantillas/web-pro/
```

---

## PASO 1 — Crear el proyecto Next.js

```bash
npx create-next-app@latest web-juanito --typescript --tailwind --eslint --app
```

### ¿Qué hace cada parte?

| Parte | Qué hace |
|-------|----------|
| `npx` | Ejecuta un paquete de npm sin instalarlo permanentemente |
| `create-next-app@latest` | El generador oficial de Next.js, última versión |
| `web-juanito` | El nombre de tu proyecto (= nombre de la carpeta que crea) |
| `--typescript` | Activa TypeScript (tipado estricto, menos bugs) |
| `--tailwind` | Instala y configura Tailwind CSS para estilos |
| `--eslint` | Instala ESLint para detectar errores de código |
| `--app` | Usa el App Router de Next.js 15 (el moderno, no el viejo Pages Router) |

**Resultado:** Te crea una carpeta `web-juanito/` con un proyecto Next.js
funcional pero vacío (solo una página de "Welcome to Next.js").

### Entrar en la carpeta del proyecto
```bash
cd web-juanito
```
> A partir de aquí, TODO se hace desde dentro de `web-juanito/`.

---

## PASO 2 — Inyectar el template de Claude Code

```bash
mkdir -p .claude/skills .claude/agents
```
> Crea las carpetas ocultas `.claude/skills/` y `.claude/agents/` dentro
> de tu proyecto. El `-p` significa "crea las carpetas padre si no existen".
> La carpeta `.claude/` es donde Claude Code busca su configuración.

```bash
cp -r ~/plantillas/web-pro/skills/* .claude/skills/
```
> Copia TODAS las skills (design-system, stripe-payments, security, etc.)
> desde tu plantilla a la carpeta del proyecto.
> `-r` = recursivo (copia carpetas y todo su contenido).

```bash
cp -r ~/plantillas/web-pro/agents/* .claude/agents/
```
> Copia TODOS los agentes (ui-designer, security-auditor, etc.)

```bash
cp ~/plantillas/web-pro/hooks/settings.json .claude/settings.json
```
> Copia la configuración de hooks (auto-format, bloqueo de comandos
> destructivos, notificación al terminar).

```bash
cp ~/plantillas/web-pro/.mcp.json .mcp.json
```
> Copia la configuración de MCP servers (Context7, Stripe, GitHub, etc.)
> Esto le dice a Claude Code qué herramientas externas tiene disponibles.

```bash
cp ~/plantillas/web-pro/CLAUDE.md.template CLAUDE.md
```
> Copia la plantilla de CLAUDE.md y la renombra a CLAUDE.md.
> Este archivo es EL MÁS IMPORTANTE — es lo primero que lee Claude Code
> cuando arranca. Contiene todo el contexto del proyecto.

### Verificar que todo está copiado
```bash
ls -la .claude/skills/
ls -la .claude/agents/
cat .claude/settings.json
```

---

## PASO 3 — Personalizar CLAUDE.md

Abre CLAUDE.md con tu editor preferido:
```bash
# Con VS Code (recomendado)
code CLAUDE.md

# O con nano en terminal
nano CLAUDE.md

# O con vim
vim CLAUDE.md
```

### Qué rellenar

El archivo tiene secciones con comentarios `<!-- -->` que te indican
qué poner. Las secciones CRÍTICAS que siempre debes rellenar son:

1. **Nombre y descripción** — Qué es el proyecto, para quién
2. **Stack** — Qué usas (el template ya sugiere Next.js + Supabase + Stripe,
   pero quita lo que no necesites)
3. **Identidad visual** — ESTO ES LO QUE HACE LA DIFERENCIA:
   - Colores exactos (primario, acento, fondo, texto)
   - Tipografías (headings y body — elegir de https://fontsource.org)
   - Estilo general (minimalista, artesanal, corporativo, bold...)
   - Inspiración (URLs de webs que te gusten)
4. **Estructura del proyecto** — Ajustar las carpetas a lo que necesites
5. **Reglas de negocio** — Lo que Claude NUNCA debe romper

### Ejemplo rápido para la web de Juanito
```markdown
# Web Juanito — Charolas Artesanales

## Descripción
Tienda online de charolas (bandejas) artesanales hechas a mano.
Venta directa al consumidor con pasarela Stripe.

## Identidad visual
- Colores:
  - Primario: #8B6914 (dorado artesanal)
  - Acento: #2D5016 (verde oliva)
  - Fondo: #FDFAF5 (crema cálido)
  - Texto: #1C1917
- Tipografía:
  - Headings: Playfair Display
  - Body: Plus Jakarta Sans
- Estilo: cálido, artesanal, premium. NO minimalista tech.
- Inspiración: etsy.com/shop/..., ceramicaartesanal.es
```

> **Truco:** Cuanto más específico seas aquí, mejor será el resultado.
> "Colores tierra con tipografía serif elegante" es 10x mejor que
> "algo bonito".

---

## PASO 4 — Configurar MCP Servers

Los MCP servers conectan Claude Code con herramientas externas.
**No necesitas TODOS — solo los que use tu proyecto.**

### Context7 (SIEMPRE instalar — es gratis y muy útil)
```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```
> Le da a Claude Code acceso a documentación actualizada de cualquier
> librería (Next.js 15, Stripe, Tailwind 4, etc.) para que no use
> código obsoleto de su entrenamiento.
>
> Uso: añade "use context7" a tu prompt cuando necesites docs frescos.

### GitHub (recomendado si usas GitHub)
```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
```
> Permite a Claude crear PRs, issues, revisar código en tu repo.
> Te pedirá autenticarte con tu cuenta de GitHub.

### Stripe (solo si el proyecto tiene pagos)
```bash
claude mcp add --transport http stripe https://mcp.stripe.com
```
> Permite a Claude crear productos, precios, checkout sessions
> directamente en tu cuenta de Stripe.
> Te pedirá autenticarte con tu cuenta de Stripe.

### Supabase (solo si usas Supabase como backend)
```bash
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp?project_ref=TU_PROJECT_REF"
```
> Acceso directo a tu base de datos, auth, storage.
> Sustituye TU_PROJECT_REF por el ref de tu proyecto en Supabase.
> ⚠️ SOLO para desarrollo, NUNCA conectar a producción.

### Playwright (para testing E2E — instalar cuando lo necesites)
```bash
claude mcp add playwright -- npx -y @anthropic-ai/mcp-server-playwright
```
> Permite a Claude abrir un navegador, navegar tu web, y verificar
> que todo funciona visualmente. Útil antes de deploy.

### Verificar MCP instalados
```bash
claude mcp list
```

---

## PASO 5 — Instalar dependencias extra

Antes de abrir Claude Code, instala las dependencias que el template asume:

```bash
# Framer Motion (animaciones)
npm install framer-motion

# React Hook Form + Zod (formularios + validación)
npm install react-hook-form @hookform/resolvers zod

# Lucide React (iconos)
npm install lucide-react

# Solo si usas Stripe:
npm install stripe @stripe/stripe-js

# Solo si usas Supabase:
npm install @supabase/supabase-js @supabase/ssr

# Solo si usas shadcn/ui como base de componentes:
npx shadcn@latest init
```

---

## PASO 6 — Abrir Claude Code y empezar

```bash
claude
```

Claude Code arranca, lee tu CLAUDE.md, detecta las skills y agentes,
y está listo. Ahora puedes pedirle cosas como:

```
> Usa el frontend-architect para planificar la landing page

> Implementa la landing page con hero, sección de productos, y footer

> Usa el ui-designer para revisar la landing page

> Implementa la integración de Stripe para comprar charolas

> Usa el security-auditor para auditar todo antes de deploy
```

---

## Resumen visual del proceso

```
┌─────────────────────────────────────────────────────┐
│  TU PC                                              │
│                                                     │
│  ~/plantillas/web-pro/     ← PLANTILLA (no tocar)   │
│    ├── skills/                                      │
│    ├── agents/                                      │
│    ├── hooks/                                       │
│    ├── .mcp.json                                    │
│    └── CLAUDE.md.template                           │
│         │                                           │
│         │  copiar ───────────────┐                  │
│         ▼                        ▼                  │
│  ~/proyectos/web-juanito/    ~/proyectos/web-otra/  │
│    ├── .claude/              ├── .claude/            │
│    │   ├── skills/ (copia)   │   ├── skills/ (copia)│
│    │   ├── agents/ (copia)   │   ├── agents/ (copia)│
│    │   └── settings.json     │   └── settings.json  │
│    ├── .mcp.json             ├── .mcp.json          │
│    ├── CLAUDE.md (editado)   ├── CLAUDE.md (editado)│
│    ├── src/ (Next.js)        ├── src/ (Next.js)     │
│    └── ...                   └── ...                │
│                                                     │
│  La plantilla se reutiliza. Cada proyecto tiene     │
│  su propia copia con su CLAUDE.md personalizado.    │
└─────────────────────────────────────────────────────┘
```

---

## Checklist rápido (copiar y pegar cada vez)

```
[ ] npx create-next-app@latest NOMBRE --typescript --tailwind --eslint --app
[ ] cd NOMBRE
[ ] mkdir -p .claude/skills .claude/agents
[ ] cp -r ~/plantillas/web-pro/skills/* .claude/skills/
[ ] cp -r ~/plantillas/web-pro/agents/* .claude/agents/
[ ] cp ~/plantillas/web-pro/hooks/settings.json .claude/settings.json
[ ] cp ~/plantillas/web-pro/.mcp.json .mcp.json
[ ] cp ~/plantillas/web-pro/CLAUDE.md.template CLAUDE.md
[ ] Editar CLAUDE.md (nombre, descripción, colores, tipografía, stack)
[ ] claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
[ ] (si pagos) claude mcp add --transport http stripe https://mcp.stripe.com
[ ] (si GitHub) claude mcp add --transport http github https://api.githubcopilot.com/mcp/
[ ] (si Supabase) claude mcp add --transport http supabase "https://mcp.supabase.com/mcp?project_ref=REF"
[ ] npm install framer-motion react-hook-form @hookform/resolvers zod lucide-react
[ ] (si pagos) npm install stripe @stripe/stripe-js
[ ] (si backend) npm install @supabase/supabase-js @supabase/ssr
[ ] claude
[ ] ¡A construir!
```

---

## Notas importantes

### La plantilla NO se modifica
`web-pro/` es tu molde maestro. Nunca la edites directamente para un
proyecto. Si quieres mejorar una skill o agente, edita `web-pro/` y
luego copia la versión nueva a tus proyectos activos.

### Cada proyecto tiene su propio CLAUDE.md
Es lo que hace cada proyecto diferente. La web de Juanito tendrá colores
dorados y tipografía serif. La web de otro cliente tendrá colores
completamente distintos. Las skills y agentes son los mismos, pero el
CLAUDE.md les dice cómo aplicarlos.

### No necesitas TODOS los MCP servers
- Proyecto simple sin pagos → solo Context7 + GitHub
- Proyecto con pagos → añadir Stripe
- Proyecto con backend/auth → añadir Supabase
- Proyecto que necesita testing visual → añadir Playwright

### Si Claude Code olvida el contexto en sesiones largas
```
> /compact
```
Esto limpia el contexto pero mantiene lo importante del CLAUDE.md.

### Para continuar donde lo dejaste
```bash
claude --continue
```

### Para ver qué tools y skills tiene Claude Code cargados
```
> /tools
```
