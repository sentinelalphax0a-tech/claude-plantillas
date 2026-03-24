# Guía de Setup — Web Pro Template

---

## ¿Primera vez o ya tienes la plantilla?

- **Primera vez** → Sección 1
- **Proyecto nuevo** (ya tienes la plantilla) → Sección 2
- **Mejorar la plantilla** → Sección 3

---

## Sección 1 — Primera vez con esta plantilla

### Requisitos previos

```bash
# Verificar versiones
node --version     # Necesitas Node 20+
git --version      # Cualquier versión reciente
claude --version   # Claude Code CLI

# Si no tienes Claude Code:
npm install -g @anthropic-ai/claude-code

# Si no tienes Node 20+:
# Instalar con nvm (recomendado):
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20

# Stripe CLI (solo si vas a usar pagos):
# macOS: brew install stripe/stripe-cli/stripe
# Windows/Linux: https://stripe.com/docs/stripe-cli
```

### Guardar la plantilla en tu sistema

```bash
# Crear directorio de plantillas en tu home
mkdir -p ~/plantillas

# Clonar el repositorio de plantillas
git clone https://github.com/sentinelalphax0a-tech/claude-plantillas ~/plantillas/claude-plantillas

# Crear alias para fácil acceso (añadir a ~/.zshrc o ~/.bashrc)
echo 'alias web-pro="cp -r ~/plantillas/claude-plantillas/plantillas/web-pro"' >> ~/.zshrc
source ~/.zshrc
```

**O bien**, si ya tienes la carpeta localmente:
```bash
# Crear symlink o copiar a ubicación permanente
cp -r /ruta/a/claude-plantillas/plantillas/web-pro ~/plantillas/web-pro
```

### Estructura que tendrás en `~/plantillas/web-pro/`

```
web-pro/
├── .mcp.json                    # Configuración de MCP servers
├── CLAUDE.md.template           # Template del contexto del proyecto
├── GUIA-SETUP.md                # Esta guía
├── GUIA-NUEVO-PROYECTO-WEB.md   # Guía específica por tipo de web
├── README.md                    # Documentación de la plantilla
├── agents/
│   ├── frontend-architect.md
│   ├── backend-architect.md
│   ├── ui-designer.md
│   ├── security-auditor.md
│   ├── qa-tester.md             # NUEVO
│   ├── mobile-reviewer.md       # NUEVO
│   └── security-pentester.md   # NUEVO
├── hooks/
│   └── settings.json
└── skills/
    ├── design-system/SKILL.md
    ├── web-builder/SKILL.md
    ├── mobile-design/SKILL.md   # NUEVO
    ├── stripe-payments/SKILL.md
    ├── security-hardening/SKILL.md
    ├── cybersecurity-pentest/SKILL.md  # NUEVO
    ├── performance-audit/SKILL.md
    ├── seo-optimizer/SKILL.md
    └── fullstack-api/SKILL.md
```

---

## Sección 2 — Proyecto nuevo (ya tienes la plantilla)

### Paso 1 — Crear el proyecto Next.js

```bash
npx create-next-app@latest nombre-de-tu-proyecto \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*"

cd nombre-de-tu-proyecto
```

### Paso 2 — Copiar la plantilla

```bash
# Crear estructura .claude
mkdir -p .claude/{skills,agents}

# Copiar todo desde tu plantilla guardada
cp -r ~/plantillas/web-pro/skills/* .claude/skills/
cp -r ~/plantillas/web-pro/agents/* .claude/agents/
cp ~/plantillas/web-pro/hooks/settings.json .claude/settings.json
cp ~/plantillas/web-pro/.mcp.json .mcp.json
cp ~/plantillas/web-pro/CLAUDE.md.template CLAUDE.md
```

### Paso 3 — Personalizar CLAUDE.md

Abre `CLAUDE.md` y reemplaza los placeholders:

```bash
# Abrir en tu editor
code CLAUDE.md
# o
nano CLAUDE.md
```

Campos a completar:
- `[NOMBRE DEL PROYECTO]` — nombre real del proyecto
- `[DESCRIPCIÓN]` — qué hace la app en 1-2 líneas
- `[URL DEL REPO]` — URL de GitHub
- `[Stack específico]` — añadir o quitar tecnologías según aplique
- Sección de negocio: qué hace, quién lo usa, qué métricas importan

### Paso 4 — MCP servers según tipo de web

#### Landing page / Portfolio (sin backend)
```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
claude mcp add playwright -- npx -y @anthropic-ai/mcp-server-playwright
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
```

#### Web con autenticación y base de datos
```bash
# Los 3 básicos +
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp?project_ref=TU_PROJECT_REF"

# Cómo obtener tu project_ref:
# Supabase Dashboard → tu proyecto → Settings → General → Reference ID
```

#### Web con pagos (Stripe)
```bash
# Los de backend +
claude mcp add --transport http stripe https://mcp.stripe.com

# Necesitas autenticarte en Stripe:
stripe login  # abre el navegador para auth
```

#### E-commerce con Shopify
```bash
# Los básicos +
claude mcp add shopify-dev -- npx -y @anthropic-ai/shopify-dev-mcp@latest

# Si tienes una tienda Shopify y quieres gestionar productos/pedidos:
claude mcp add shopify -- npx shopify-mcp \
  --accessToken TU_ACCESS_TOKEN \
  --domain TU-TIENDA.myshopify.com

# Cómo obtener el access token:
# Shopify Admin → Apps → Develop apps → Create app → API credentials
```

#### Web con CMS en Notion
```bash
# Los de backend +
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Necesitas API key de Notion:
# notion.so/my-integrations → New integration → Internal
# Luego: export NOTION_API_KEY=secret_xxxxx en tu .env.local
```

#### Web en producción con monitorización
```bash
# Añadir Sentry cuando la app esté live:
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
```

### Paso 5 — Dependencias npm según tipo

```bash
# BASE (todas las webs)
npm install zod
npm install @hookform/resolvers react-hook-form
npm install clsx tailwind-merge
npm install lucide-react

# Con Supabase
npm install @supabase/supabase-js @supabase/ssr

# Con Stripe
npm install stripe @stripe/stripe-js @stripe/react-stripe-js

# Con pagos + Supabase (subscriptions completas)
npm install stripe @stripe/stripe-js @stripe/react-stripe-js @supabase/supabase-js @supabase/ssr

# Seguridad (uploads)
npm install file-type isomorphic-dompurify

# Rate limiting (recomendado siempre)
npm install @upstash/ratelimit @upstash/redis

# Passwords (si haces tu propio auth sin Supabase)
npm install @node-rs/argon2
# o
npm install bcryptjs @types/bcryptjs
```

### Paso 6 — Variables de entorno

```bash
# Crear .env.local
touch .env.local

# Verificar que está en .gitignore
grep ".env.local" .gitignore || echo ".env.local" >> .gitignore
```

Variables por tipo:
```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...  # NUNCA con NEXT_PUBLIC_

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...  # NUNCA con NEXT_PUBLIC_
STRIPE_WEBHOOK_SECRET=whsec_...

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### Paso 7 — Lanzar

```bash
npm run dev
claude  # En otra terminal
```

---

## Checklist express (todo en un copy-paste)

```bash
# 1. Crear proyecto
npx create-next-app@latest mi-proyecto --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
cd mi-proyecto

# 2. Copiar plantilla
mkdir -p .claude/{skills,agents}
cp -r ~/plantillas/web-pro/skills/* .claude/skills/
cp -r ~/plantillas/web-pro/agents/* .claude/agents/
cp ~/plantillas/web-pro/hooks/settings.json .claude/settings.json
cp ~/plantillas/web-pro/.mcp.json .mcp.json
cp ~/plantillas/web-pro/CLAUDE.md.template CLAUDE.md

# 3. MCP mínimos
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
claude mcp add playwright -- npx -y @anthropic-ai/mcp-server-playwright
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 4. Dependencias base
npm install zod @hookform/resolvers react-hook-form clsx tailwind-merge lucide-react

# 5. Env
touch .env.local
echo ".env.local" >> .gitignore  # ya debería estar, doble check

# 6. Git
git init && git add . && git commit -m "Initial commit: web-pro template"
gh repo create mi-proyecto --public --source=. --remote=origin --push

# 7. Editar CLAUDE.md y lanzar
claude
```

---

## Sección 3 — Actualizar la plantilla

### Has mejorado algo en web-pro/ y quieres conservarlo

```bash
# Desde el directorio del repo de plantillas
cd ~/plantillas/claude-plantillas

# Ver qué cambió
git diff plantillas/web-pro/

# Commit del cambio
git add plantillas/web-pro/
git commit -m "web-pro: [descripción del cambio]"
git push
```

### Propagar cambios a proyectos activos

Los proyectos existentes NO se actualizan automáticamente (es intencional — evita romper proyectos en producción).

Para propagar una mejora específica:

```bash
# Opción A: copiar solo el archivo que cambió
cp ~/plantillas/web-pro/skills/mobile-design/SKILL.md ~/mis-proyectos/proyecto-activo/.claude/skills/mobile-design/SKILL.md

# Opción B: diff y aplicar manualmente
diff ~/plantillas/web-pro/agents/qa-tester.md ~/mis-proyectos/proyecto-activo/.claude/agents/qa-tester.md

# Opción C: re-copiar todo (cuidado — sobreescribe customizaciones del proyecto)
cp -r ~/plantillas/web-pro/skills/* ~/mis-proyectos/proyecto-activo/.claude/skills/
cp -r ~/plantillas/web-pro/agents/* ~/mis-proyectos/proyecto-activo/.claude/agents/
# NO copiar CLAUDE.md ni .mcp.json (tienen configuración específica del proyecto)
```

**Regla**: solo propaga si la mejora es relevante para ese proyecto activo.
No propagues cambios a proyectos en producción sin revisar el diff primero.

---

## Solución de problemas

### Claude no usa las skills

```bash
# Verificar que los archivos están en el lugar correcto
ls .claude/skills/
# Deben aparecer: design-system, web-builder, mobile-design, etc.

# Verificar permisos
ls -la .claude/skills/mobile-design/SKILL.md

# Si las skills son nuevas, reiniciar Claude Code
# Ctrl+C → claude
```

### MCP server no conecta

```bash
# Ver estado de MCP servers
claude mcp list

# Ver logs de un servidor específico
claude mcp get context7

# Si da error de permisos:
claude mcp remove context7
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```

### Los hooks no se ejecutan

```bash
# Verificar que el archivo existe
cat .claude/settings.json

# Verificar permisos del archivo
chmod 644 .claude/settings.json

# Verificar sintaxis JSON válida
node -e "JSON.parse(require('fs').readFileSync('.claude/settings.json', 'utf8'))"
```

### Supabase MCP no conecta

```bash
# 1. Verificar que el project_ref es correcto
# Supabase Dashboard → Settings → General → Reference ID
# Ejemplo: abcdefghijklmnop (16 caracteres)

# 2. Verificar autenticación
# Claude Code necesita estar autenticado con Supabase
# Ejecutar en la terminal de Claude Code:
# > Conéctate a Supabase con project ref TU_REF

# 3. Si persiste, usar conexión directa PostgreSQL
claude mcp add postgres -- npx -y @modelcontextprotocol/server-postgres "postgresql://..."
```
