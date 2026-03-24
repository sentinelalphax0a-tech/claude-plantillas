# Guía Profesional de Claude Code: Agentes, Skills, MCP y Más

> **Autor:** Guía personalizada para Alex — Ingeniería Informática USAL  
> **Fecha:** Marzo 2026  
> **Enfoque:** Sentinel Alpha, Proyectos Web/Influencer, Desarrollo General

---

## Tabla de Contenidos

1. [¿Qué es Claude Code y por qué es más que un asistente de código?](#1-qué-es-claude-code)
2. [Instalación y Configuración Inicial](#2-instalación-y-configuración)
3. [CLAUDE.md — El Cerebro Persistente de tu Proyecto](#3-claudemd)
4. [Slash Commands — Workflows Repetibles](#4-slash-commands)
5. [MCP (Model Context Protocol) — Conectar con el Mundo Exterior](#5-mcp)
6. [Agent Skills — Expertise On-Demand](#6-agent-skills)
7. [Subagentes — Tu Equipo de IA Especializado](#7-subagentes)
8. [Hooks — Automatización Determinista](#8-hooks)
9. [Plugins — Empaquetar y Compartir Todo](#9-plugins)
10. [Caso Práctico: Sentinel Alpha](#10-sentinel-alpha)
11. [Caso Práctico: Web del Influencer / "Esto te interesa"](#11-web-influencer)
12. [Caso Práctico: Roblox Game Dev](#12-roblox-game-dev)
13. [Arquitectura Multi-Agente: Patrones Avanzados](#13-patrones-avanzados)
14. [CLI Avanzado y Trucos de Terminal](#14-cli-avanzado)
15. [Mejores Prácticas y Errores Comunes](#15-mejores-prácticas)
16. [Recursos y Referencias](#16-recursos)

---

## 1. ¿Qué es Claude Code?

Claude Code **no es simplemente un asistente de código**. Es un **framework de orquestación de agentes de IA** que opera desde tu terminal, IDE, escritorio o navegador. Puede:

- Leer y entender tu codebase completo
- Editar archivos, ejecutar comandos, gestionar git
- Conectarse a APIs externas (GitHub, Slack, bases de datos, Google Drive...)
- Crear y coordinar **equipos de agentes especializados**
- Ejecutarse en pipelines CI/CD (GitHub Actions)
- Automatizar cualquier cosa que puedas hacer escribiendo comandos

**Analogía:** Piensa en Claude Code como un **junior developer superinteligente** al que le puedes dar instrucciones permanentes (CLAUDE.md), enseñarle habilidades nuevas (Skills), conectarle a tus herramientas (MCP), asignarle un equipo (Subagentes), y poner reglas automáticas (Hooks).

### La Pila Completa de Features

```
┌─────────────────────────────────────────────┐
│              TU PROYECTO                     │
│                                              │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐  │
│  │ CLAUDE.md│  │ Skills   │  │ Commands  │  │
│  │ (memoria │  │ (expert. │  │ (atajos   │  │
│  │  estática│  │  dynamic)│  │  manuales)│  │
│  └──────────┘  └──────────┘  └───────────┘  │
│                                              │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐  │
│  │Subagentes│  │  Hooks   │  │  Plugins  │  │
│  │ (equipo  │  │ (autom.  │  │ (paquetes │  │
│  │  de IA)  │  │  reglas) │  │  distrib.)│  │
│  └──────────┘  └──────────┘  └───────────┘  │
│                                              │
│  ┌──────────────────────────────────────┐    │
│  │     MCP (Conexiones Externas)        │    │
│  │  GitHub · Slack · DB · APIs · Drive  │    │
│  └──────────────────────────────────────┘    │
└─────────────────────────────────────────────┘
```

---

## 2. Instalación y Configuración

### Requisitos Previos

- **Node.js** v18+ (recomendado v20 LTS)
- **npm** o **yarn**
- Una suscripción a Claude (Pro/Max/Team) o cuenta en Anthropic Console
- Git instalado

### Instalación

```bash
# Instalación global via npm
npm install -g @anthropic-ai/claude-code

# Verificar instalación
claude --version

# Primera ejecución (te pedirá autenticarte)
claude
```

### Configuración Inicial Recomendada

```bash
# Configurar modelo preferido (Opus para tareas complejas, Sonnet para velocidad)
claude config set model claude-sonnet-4-20250514

# Activar auto-memoria
claude config set memory true

# Ver tu configuración actual
claude config list
```

### Entornos Disponibles

| Entorno | Uso ideal | Notas |
|---------|-----------|-------|
| **Terminal CLI** | Desarrollo full-stack, scripts, CI/CD | El más potente y personalizable |
| **VS Code Extension** | Desarrollo cotidiano en IDE | Integración nativa con el editor |
| **JetBrains Plugin** | Si usas IntelliJ/PyCharm | Mismas capacidades |
| **Desktop App** | Trabajo general sin terminal | Más visual |
| **Web (Remote Control)** | Cuando estás fuera del PC | Continuar sesiones desde móvil |

> **Importante:** Todos los entornos comparten los mismos archivos CLAUDE.md, settings y servidores MCP.

---

## 3. CLAUDE.md — El Cerebro Persistente de tu Proyecto

El archivo `CLAUDE.md` en la raíz de tu proyecto es **lo más importante**. Claude lo lee al inicio de cada sesión. Es tu forma de dar contexto permanente.

### Estructura Recomendada

```markdown
# CLAUDE.md

## Descripción del Proyecto
Sentinel Alpha es un sistema de detección de insider trading para mercados
de predicción (Polymarket). Monitoriza transacciones blockchain, puntúa
comportamientos sospechosos de wallets con sistema de estrellas, y usa
algoritmos union-find para agrupación de wallets.

## Stack Tecnológico
- Backend: Python 3.11+, FastAPI
- Base de datos: PostgreSQL con pgvector
- Blockchain: Web3.py, Alchemy API
- Frontend Dashboard: React + Tailwind CSS
- Infraestructura: Mac Mini M4, 32GB RAM, 4TB SSD externo

## Convenciones de Código
- PEP 8 estricto para Python
- Docstrings en español para funciones públicas
- Type hints obligatorios
- Nombres de variables en inglés, comentarios en español
- Commits en inglés con formato: `feat:`, `fix:`, `refactor:`, `docs:`

## Estructura del Proyecto
```
sentinel-alpha/
├── src/
│   ├── ml1/          # Modelo ML1: detección de insiders
│   ├── ml2/          # Modelo ML2: correlación cross-market
│   ├── filters/      # Filtros W04, W05, W09, B20, B23, B28, N06, B32
│   ├── blockchain/   # Conexión a Polymarket/blockchain
│   ├── dashboard/    # React dashboard público
│   └── utils/        # Utilidades comunes
├── scripts/
│   ├── cleaner_post_deep.py
│   └── deploy/
├── tests/
└── docs/
```

## Comandos Importantes
- Tests: `pytest tests/ -v --tb=short`
- Lint: `ruff check src/`
- Formato: `black src/`
- Migración DB: `alembic upgrade head`
- Dashboard dev: `cd src/dashboard && npm run dev`

## Reglas de Negocio Críticas
- Las alertas usan sistema de 1-5 estrellas para severidad
- El filtro B32 (wallet repeat-performance) requiere mínimo 5-7
  apariciones por wallet para significancia estadística
- Union-find agrupa wallets relacionadas; NUNCA modificar el algoritmo
  sin revisar los tests de regresión
- El dashboard usa autenticación por URL-parameter

## Notas de Debugging
- False positives comunes en filtros W04/W05 → usar cleaner_post_deep.py
- Si el scraper de blockchain falla, verificar API key de Alchemy
- PostgreSQL tiende a bloquearse con queries de agrupación >10K wallets
```

### Niveles de CLAUDE.md

Claude busca archivos CLAUDE.md en múltiples ubicaciones (de más general a más específico):

```
~/.config/claude/CLAUDE.md          # Global (tus preferencias personales)
~/projects/sentinel-alpha/CLAUDE.md # Raíz del proyecto
~/projects/sentinel-alpha/src/ml1/CLAUDE.md  # Subdirectorio específico
```

**Ejemplo de CLAUDE.md global (`~/.config/claude/CLAUDE.md`):**

```markdown
# Preferencias Globales de Alex

## Idioma
- Código: inglés
- Comentarios y docs: español
- Commits: inglés

## Estilo de comunicación
- Sé directo y conciso
- Usa analogías cuando expliques conceptos nuevos
- Si hay múltiples enfoques, preséntame los 2 mejores con pros/contras
- Cuando edites código, explica el porqué del cambio

## Herramientas preferidas
- Python: usar `ruff` para linting, `black` para formato
- JavaScript: usar `prettier` y `eslint`
- Testing: `pytest` para Python, `vitest` para JS
- Git: siempre hacer commits atómicos
```

### Auto-Memoria

Además del CLAUDE.md manual, Claude Code genera **memorias automáticas** conforme trabaja. Aprende cosas como:

- Comandos de build que descubre
- Patrones de debugging que funcionaron
- Peculiaridades de tu codebase

Estas se guardan en `.claude/memory/` y persisten entre sesiones.

---

## 4. Slash Commands — Workflows Repetibles

Los Slash Commands son **prompts guardados** que invocas manualmente con `/nombre`. Perfectos para tareas que repites frecuentemente.

### Crear un Slash Command

Los comandos se guardan como archivos `.md` en:

```
.claude/commands/           # Comandos del proyecto (compartidos con el equipo via git)
~/.claude/commands/         # Comandos personales (solo para ti)
```

### Ejemplos Prácticos

**`.claude/commands/review-alerts.md`** — Revisar alertas de Sentinel Alpha:

```markdown
Analiza las últimas alertas generadas por el sistema de detección.

1. Lee los logs recientes: `tail -500 logs/alerts.log`
2. Cuenta alertas por filtro (W04, W05, B20, etc.)
3. Identifica posibles false positives según los criterios del CLAUDE.md
4. Genera un resumen en formato tabla:
   - Filtro | Alertas Totales | Probables FP | Acción Recomendada
5. Si hay alguna alerta de 4-5 estrellas, destácala al principio
```

**`.claude/commands/deploy-dashboard.md`** — Deploy del dashboard:

```markdown
Ejecuta el proceso de deploy del dashboard público:

1. Ejecuta los tests del frontend: `cd src/dashboard && npm test`
2. Si pasan, haz build: `npm run build`
3. Verifica que el build no tiene errores
4. Muestra el tamaño del bundle y compáralo con el último deploy
5. Si todo está bien, confirma antes de hacer push
```

**`~/.claude/commands/new-feature.md`** — Comando personal para nueva feature:

```markdown
Quiero implementar una nueva feature. Antes de escribir código:

1. Busca en el codebase si ya existe algo similar
2. Identifica los archivos que probablemente necesitaremos modificar
3. Propón un plan de implementación con pasos numerados
4. Estima la complejidad (baja/media/alta)
5. Identifica tests que necesitaremos añadir

Feature a implementar: $ARGUMENTS
```

### Uso

```bash
# En la terminal de Claude Code:
/review-alerts
/deploy-dashboard
/new-feature Añadir filtro B32 de repeat-performance para wallets
```

> **Tip:** Los `$ARGUMENTS` capturan todo lo que escribas después del comando.

---

## 5. MCP (Model Context Protocol) — Conectar con el Mundo Exterior

MCP es un **protocolo estándar abierto** que conecta Claude Code con herramientas y fuentes de datos externas. Es como un "USB-C universal para IA".

### Conceptos Clave

```
┌──────────────────────┐
│     Claude Code      │
│   (Cliente MCP)      │
│                      │
└───────┬──────────────┘
        │
  ┌─────┴─────┐
  │           │
  ▼           ▼
┌──────┐  ┌──────┐
│Server│  │Server│
│ MCP  │  │ MCP  │
│GitHub│  │ DB   │
└──────┘  └──────┘
```

- **Cliente MCP:** Claude Code actúa como cliente
- **Servidor MCP:** Cada herramienta expone un servidor con "tools" que Claude puede usar
- **Transporte:** stdio (local) o HTTP/SSE (remoto)

### Configuración de Servidores MCP

Los servidores se configuran en `.mcp.json` en la raíz del proyecto o en `~/.config/claude/mcp.json` para configuración global:

**`.mcp.json` — Ejemplo para Sentinel Alpha:**

```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost:5432/sentinel_alpha"
      }
    },
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y", "@modelcontextprotocol/server-filesystem",
        "/home/alex/projects/sentinel-alpha/data",
        "/home/alex/projects/sentinel-alpha/logs"
      ]
    },
    "slack": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"
      }
    }
  }
}
```

### Servidores MCP Útiles para tus Proyectos

| Servidor | Paquete npm | Uso para ti |
|----------|-------------|-------------|
| **GitHub** | `@modelcontextprotocol/server-github` | Gestionar repos de Sentinel, PRs, issues |
| **PostgreSQL** | `@modelcontextprotocol/server-postgres` | Consultar la DB de alertas/wallets directamente |
| **Filesystem** | `@modelcontextprotocol/server-filesystem` | Acceder a logs y datos fuera del repo |
| **Brave Search** | `@anthropic-ai/mcp-server-brave-search` | Buscar info de crypto/mercados en tiempo real |
| **Memory** | `@modelcontextprotocol/server-memory` | Memoria persistente tipo knowledge graph |
| **Google Drive** | Servidor oficial de Google | Acceder a docs compartidos del equipo |
| **Puppeteer** | `@anthropic-ai/mcp-server-puppeteer` | Scraping web, testing visual del dashboard |

### Ejemplo de Uso Real

Una vez configurado, puedes hacer cosas como:

```
> Revisa los últimos 3 issues abiertos en el repo sentinel-alpha de GitHub
  y correlaciona con las alertas de las últimas 24h en la DB de PostgreSQL.
  Si encuentras algún false positive recurrente, crea un issue nuevo con
  la propuesta de fix.
```

Claude Code automáticamente:
1. Usa el MCP de GitHub para leer los issues
2. Usa el MCP de PostgreSQL para consultar la DB
3. Correlaciona la información
4. Vuelve a usar GitHub MCP para crear el issue

### MCP con el Agent SDK (Programático)

Si estás construyendo agentes programáticos con el SDK:

```javascript
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Analiza las alertas de las últimas 24h y genera un reporte",
  options: {
    mcpServers: {
      "sentinel-db": {
        type: "stdio",
        command: "npx",
        args: ["-y", "@modelcontextprotocol/server-postgres"],
        env: { DATABASE_URL: process.env.SENTINEL_DB_URL }
      }
    },
    allowedTools: ["mcp__sentinel-db__*"]
  }
})) {
  if (message.type === "result" && message.subtype === "success") {
    console.log(message.result);
  }
}
```

### Crear tu Propio Servidor MCP

Para Sentinel Alpha, podrías crear un servidor MCP personalizado que exponga herramientas específicas:

```python
# sentinel_mcp_server.py
from mcp.server import Server
from mcp.types import Tool, TextContent

server = Server("sentinel-alpha")

@server.tool("get_alerts")
async def get_alerts(severity_min: int = 3, hours: int = 24) -> list:
    """Obtiene alertas recientes filtradas por severidad mínima."""
    # Consulta tu DB de alertas
    alerts = await db.fetch_alerts(severity_min=severity_min, hours=hours)
    return [TextContent(type="text", text=format_alerts(alerts))]

@server.tool("check_wallet")
async def check_wallet(address: str) -> dict:
    """Analiza una wallet específica: historial, agrupaciones, puntuación."""
    wallet_info = await analyze_wallet(address)
    return [TextContent(type="text", text=json.dumps(wallet_info, indent=2))]

@server.tool("run_filter")
async def run_filter(filter_name: str, dry_run: bool = True) -> str:
    """Ejecuta un filtro específico (B20, W04, etc.) opcionalmente en dry-run."""
    result = await execute_filter(filter_name, dry_run=dry_run)
    return [TextContent(type="text", text=result)]

if __name__ == "__main__":
    server.run()
```

Luego en tu `.mcp.json`:

```json
{
  "mcpServers": {
    "sentinel": {
      "type": "stdio",
      "command": "python",
      "args": ["sentinel_mcp_server.py"]
    }
  }
}
```

---

## 6. Agent Skills — Expertise On-Demand

Las Skills son **paquetes de expertise reutilizable** que Claude carga dinámicamente cuando detecta que son relevantes. A diferencia del CLAUDE.md (que se carga siempre), las Skills se activan solo cuando hacen falta.

### Anatomía de una Skill

```
.claude/skills/
└── sentinel-analyzer/
    ├── SKILL.md           # Documentación principal (obligatorio)
    ├── scripts/
    │   ├── analyze_wallet.py
    │   └── generate_report.py
    ├── references/
    │   └── filter_docs.md
    └── assets/
        └── report_template.html
```

**La clave es el `SKILL.md`:**

```markdown
---
name: sentinel-analyzer
description: >
  Analiza alertas de insider trading en Sentinel Alpha. Usa esta skill
  cuando el usuario pida analizar wallets, revisar alertas, ejecutar
  filtros, o generar reportes del sistema de detección.
---

# Sentinel Analyzer Skill

## Cuándo usar esta skill
- Análisis de wallets sospechosas
- Revisión de alertas por filtro
- Generación de reportes de actividad
- Debugging de false positives

## Workflow de Análisis

### 1. Análisis rápido de wallet
```bash
python scripts/analyze_wallet.py --address <wallet_address>
```
Esto devuelve: puntuación de estrellas, mercados participados,
markets_won/markets_lost, agrupaciones union-find.

### 2. Revisión de alertas por filtro
Para cada filtro, el script genera estadísticas:
```bash
python scripts/generate_report.py --filter B20 --hours 24
```

### 3. Criterios de false positive
- **W04/W05**: Verificar si el volumen es orgánico (>10 transacciones
  distribuidas en >6 horas)
- **B20**: Comprobar si la wallet tiene historial legítimo (>30 días
  de actividad previa)
- **B23/B28**: Correlacionar con eventos de mercado conocidos
- **N06**: Verificar si es un market maker conocido

## Formato de Reporte
Siempre generar en formato tabla con:
| Wallet | Estrellas | Filtro | Mercado | Acción |

## Notas
- El filtro B32 (repeat-performance) aún no está activo;
  se activará cuando haya ~8K-10K resolved alerts (~Q1 2027)
- Mínimo 5-7 apariciones por wallet para significancia estadística
```

### Cómo se Cargan las Skills (Progressive Disclosure)

```
1. SIEMPRE visible: Nombre + Descripción de la skill (en system prompt)
   → Claude lee esto y decide si es relevante

2. Si es relevante: Claude ejecuta `read SKILL.md`
   → Carga las instrucciones completas

3. Si necesita más: Claude lee archivos en scripts/, references/
   → Carga solo lo que necesita
```

**Esto es eficiente:** no se desperdicia contexto cargando todo siempre.

### Skills vs CLAUDE.md vs Slash Commands

| Feature | Cuándo usar | Activación |
|---------|-------------|------------|
| **CLAUDE.md** | Info que SIEMPRE es relevante (stack, convenciones, estructura) | Automática, siempre |
| **Skills** | Expertise específica que solo a veces hace falta | Automática, por contexto |
| **Slash Commands** | Workflows que TÚ decides cuándo ejecutar | Manual, con `/comando` |

### Dónde Guardar Skills

```
~/.config/claude/skills/          # Skills personales (todas tus proyectos)
.claude/skills/                    # Skills del proyecto (compartidas via git)
```

### Skill para tu Canal "Esto te interesa"

```markdown
---
name: content-creator
description: >
  Ayuda a crear contenido para el canal de YouTube "Esto te interesa".
  Usa para scripts de video, thumbnails, títulos SEO, descripciones,
  y planificación de contenido sobre tecnología, privacidad y crypto.
---

# Content Creator Skill — "Esto te interesa"

## Estilo del Canal
- Tono: informativo pero accesible, como explicar tech a un amigo
- Idioma: español (España), con anglicismos tech naturales
- Duración objetivo: 8-15 minutos por video
- Formato: intro hook (10s) → contexto → contenido → conclusión + CTA

## Estructura de Script
1. **Hook** (0:00-0:10): Pregunta provocadora o dato impactante
2. **Intro** (0:10-0:30): "Hoy vamos a hablar de..."
3. **Contexto** (0:30-2:00): Por qué importa este tema
4. **Contenido principal** (2:00-10:00): 3-5 puntos clave
5. **Conclusión** (10:00-11:00): Resumen + opinión personal
6. **CTA** (11:00-11:30): Like, subscribe, comentario

## Temáticas Principales
- Privacidad digital (GrapheneOS, Tor, VPN)
- Criptomonedas (Bitcoin, XRP, DeFi)
- Tecnología emergente (IA, drones, automation)
- Seguridad informática

## Optimización SEO
- Títulos: máx 60 caracteres, incluir keyword principal
- Thumbnail: texto grande, 3 colores max, cara o emoji
- Descripción: keyword en primera línea, timestamps, links
- Tags: 15-20 relevantes, mezcla de genéricos y específicos

## Scripts Disponibles
```bash
# Generar ideas de contenido basadas en tendencias
python scripts/trending_topics.py --niche "tech privacy crypto"

# Analizar competencia
python scripts/competitor_analysis.py --channel <channel_id>
```
```

---

## 7. Subagentes — Tu Equipo de IA Especializado

Los subagentes son **agentes independientes con su propio contexto, prompt de sistema y permisos de herramientas**. El agente principal puede delegarles tareas.

### Por qué son útiles

Sin subagentes:
```
[Agente Principal]
  → Investiga el bug (usa 50K tokens de contexto)
  → Escribe el fix (30K tokens más)
  → Escribe tests (20K tokens más)
  → Total: 100K tokens en una sola ventana = confusión
```

Con subagentes:
```
[Agente Principal]
  ├── [Subagente Investigador] → Resume: "Bug en filtro B20, línea 47"
  ├── [Subagente Developer]    → Resume: "Fix aplicado, 3 archivos"
  └── [Subagente Tester]       → Resume: "8/8 tests pasando"
  → Total en ventana principal: solo los resúmenes
```

### Crear Subagentes

Se definen como archivos `.md` con YAML frontmatter:

```
.claude/agents/           # Agentes del proyecto
~/.claude/agents/         # Agentes personales
```

**Método 1: Usar el comando `/agents`**

```
> /agents
→ Select: Create new agent
→ Scope: Personal (o Project)
→ Generate with Claude: "Un agente de code review que revise
   seguridad, rendimiento y mejores prácticas de Python"
```

**Método 2: Crear manualmente**

**`.claude/agents/sentinel-investigator.md`:**

```markdown
---
name: sentinel-investigator
description: >
  Investiga alertas sospechosas en Sentinel Alpha. Analiza patrones
  de wallets, correlaciona con datos de mercado, y determina si una
  alerta es un true positive o false positive.
tools: Read, Grep, Glob, Bash
model: sonnet
---

Eres un investigador especializado en detección de insider trading
en mercados de predicción.

## Tu proceso de investigación:

1. **Recopilar datos**: Lee los logs y la DB para entender la alerta
2. **Analizar patrones**: Busca patrones temporales en las transacciones
3. **Correlacionar**: Compara con comportamiento normal del mercado
4. **Clasificar**: Determina true positive / false positive / inconcluso
5. **Documentar**: Genera un reporte breve con tu conclusión

## Formato de salida:
```
ALERTA: [ID]
WALLET: [address]
FILTRO: [nombre]
CLASIFICACIÓN: [TP/FP/INCONCLUSO]
CONFIANZA: [alta/media/baja]
EVIDENCIA: [resumen en 2-3 líneas]
ACCIÓN RECOMENDADA: [descripción]
```

## Reglas:
- NUNCA modifiques la base de datos
- NUNCA ejecutes scripts que modifiquen datos
- Solo operaciones de lectura
```

**`.claude/agents/code-reviewer.md`:**

```markdown
---
name: code-reviewer
description: >
  Revisa código para calidad, seguridad, rendimiento y mejores prácticas.
  Especializado en Python y JavaScript/React.
tools: Read, Grep, Glob
memory: project
---

Eres un code reviewer senior. Tu trabajo es revisar código y sugerir
mejoras.

## Checklist de revisión:

### Seguridad
- [ ] No hay credenciales hardcodeadas
- [ ] Inputs sanitizados
- [ ] No hay SQL injection posible
- [ ] No hay XSS posible
- [ ] Dependencias sin vulnerabilidades conocidas

### Rendimiento
- [ ] No hay N+1 queries
- [ ] Uso apropiado de índices en DB
- [ ] No hay memory leaks obvios
- [ ] Algoritmos con complejidad razonable

### Calidad
- [ ] Nombres descriptivos
- [ ] Funciones con responsabilidad única
- [ ] Type hints (Python) / TypeScript types
- [ ] Manejo de errores apropiado
- [ ] Tests unitarios presentes

## Formato de output:
Para cada issue encontrado:
- **Severidad**: 🔴 Crítico | 🟡 Medio | 🟢 Bajo
- **Archivo**: path/al/archivo.py:línea
- **Issue**: Descripción del problema
- **Fix**: Código sugerido

Actualiza tu memoria de agente con patrones y convenciones que descubras.
```

**`.claude/agents/web-builder.md`:**

```markdown
---
name: web-builder
description: >
  Construye y modifica sitios web y aplicaciones frontend.
  Especializado en HTML/CSS/JS, React, Tailwind CSS.
  Usa para proyectos web como el sitio del influencer,
  dashboards, landing pages.
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
---

Eres un desarrollador frontend senior especializado en crear
sitios web modernos, rápidos y responsive.

## Stack preferido:
- React + Vite para SPAs
- Tailwind CSS para estilos
- HTML/CSS/JS vanilla para sitios simples
- Next.js si se necesita SSR/SSG

## Principios de diseño:
- Mobile-first siempre
- Performance: Core Web Vitals en verde
- Accesibilidad: WCAG 2.1 AA mínimo
- SEO: metadata, structured data, sitemap

## Workflow:
1. Entender los requisitos
2. Crear estructura de archivos
3. Implementar layout responsive
4. Añadir interactividad
5. Optimizar performance
6. Verificar en múltiples viewports
```

### Ejecución en Paralelo

Claude Code puede lanzar múltiples subagentes simultáneamente:

```
> Necesito preparar el release de Sentinel Alpha v2.3. En paralelo:
  1. Que el investigador analice las últimas 50 alertas
  2. Que el code-reviewer revise los cambios desde el último tag
  3. Que el web-builder verifique que el dashboard no tiene errores
```

Claude internamente usa la herramienta `Task` para crear los tres subagentes, cada uno con su propio contexto, y luego recoge los resultados.

### El Subagente Especial: Explore

Claude Code tiene un subagente built-in llamado **Explore** que es de solo lectura. Ideal para:

```
> Usa Explore para encontrar todos los archivos donde se usa el
  filtro B20 y hazme un resumen de cómo funciona
```

Explore no puede escribir ni ejecutar comandos destructivos, así que es seguro para investigación.

---

## 8. Hooks — Automatización Determinista

Los Hooks son **comandos shell que se ejecutan automáticamente** en momentos específicos del ciclo de vida de Claude Code. A diferencia de las Skills (que son probabilísticas), los Hooks son **deterministas**: se ejecutan SIEMPRE cuando la condición se cumple.

### Eventos Disponibles

| Evento | Cuándo se ejecuta | Uso típico |
|--------|-------------------|------------|
| `PreToolUse` | Antes de que Claude use una herramienta | Validar, bloquear, modificar |
| `PostToolUse` | Después de usar una herramienta | Formatear, verificar, notificar |
| `Stop` | Cuando Claude termina de responder | Notificaciones, cleanup |
| `SubagentStop` | Cuando un subagente termina | Log, notificaciones |
| `PreCompact` | Antes de compactar el contexto | Backup de transcripción |
| `SessionStart` | Al iniciar o reanudar sesión | Cargar contexto, env setup |

### Configurar Hooks

Los hooks se configuran en los settings de Claude Code:

**`.claude/settings.json` (nivel proyecto):**

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "cd $CLAUDE_PROJECT_DIR && ruff check --fix $CLAUDE_FILE_PATH 2>/dev/null || true"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/scripts/hooks/validate_command.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude ha terminado\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

### Ejemplos Prácticos de Hooks

**Auto-formatear Python después de cada edición:**

```json
{
  "PostToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "cd $CLAUDE_PROJECT_DIR && black $CLAUDE_FILE_PATH 2>/dev/null; ruff check --fix $CLAUDE_FILE_PATH 2>/dev/null || true"
      }]
    }
  ]
}
```

**Bloquear comandos peligrosos (exit code 2 = bloquear):**

```bash
#!/bin/bash
# scripts/hooks/validate_command.sh
# Lee el input JSON de stdin

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Bloquear comandos destructivos en producción
if echo "$COMMAND" | grep -qE '(rm -rf /|DROP TABLE|DELETE FROM.*WHERE 1|shutdown)'; then
    echo "BLOQUEADO: Comando potencialmente destructivo detectado" >&2
    exit 2  # Exit code 2 = bloquear la acción
fi

exit 0  # Exit code 0 = permitir
```

**Notificación de escritorio cuando Claude termina (macOS):**

```json
{
  "Stop": [
    {
      "hooks": [{
        "type": "command",
        "command": "osascript -e 'display notification \"Tarea completada\" with title \"Claude Code\" sound name \"Glass\"'"
      }]
    }
  ]
}
```

**Para Linux (notify-send):**

```json
{
  "Stop": [
    {
      "hooks": [{
        "type": "command",
        "command": "notify-send 'Claude Code' 'Tarea completada' --icon=dialog-information"
      }]
    }
  ]
}
```

**Auto-ejecutar tests después de modificar archivos de test:**

```json
{
  "PostToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "if echo $CLAUDE_FILE_PATH | grep -q 'test_'; then cd $CLAUDE_PROJECT_DIR && pytest $CLAUDE_FILE_PATH -x --tb=short 2>&1 | tail -20; fi"
      }]
    }
  ]
}
```

---

## 9. Plugins — Empaquetar y Compartir Todo

Los Plugins son **bundles distribuibles** que empaquetan skills, commands, hooks, subagentes y configuración MCP en una sola unidad instalable.

### Estructura de un Plugin

```
mi-plugin/
├── plugin.json            # Metadata y configuración
├── skills/
│   └── mi-skill/
│       └── SKILL.md
├── commands/
│   └── mi-comando.md
├── agents/
│   └── mi-agente.md
├── hooks/
│   └── mi-hook.sh
└── README.md
```

### Instalar Plugins

```bash
# Desde el marketplace
/plugins install @anthropic/skill-creator

# Desde un repo git
/plugins install https://github.com/tu-usuario/tu-plugin

# Ver plugins instalados
/plugins list
```

### Crear tu Propio Plugin para Sentinel Alpha

```json
// plugin.json
{
  "name": "sentinel-alpha-toolkit",
  "version": "1.0.0",
  "description": "Herramientas completas para desarrollo de Sentinel Alpha",
  "skills": ["skills/sentinel-analyzer"],
  "agents": ["agents/sentinel-investigator", "agents/code-reviewer"],
  "commands": ["commands/review-alerts", "commands/deploy-dashboard"],
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [{"type": "command", "command": "hooks/auto-format.sh"}]
      }
    ]
  }
}
```

---

## 10. Caso Práctico: Sentinel Alpha

### Setup Completo del Proyecto

```
sentinel-alpha/
├── CLAUDE.md                    # Contexto del proyecto
├── .mcp.json                    # Servidores MCP
├── .claude/
│   ├── settings.json            # Hooks del proyecto
│   ├── commands/
│   │   ├── review-alerts.md     # Revisar alertas
│   │   ├── analyze-wallet.md    # Analizar wallet
│   │   ├── run-filters.md       # Ejecutar filtros
│   │   └── deploy.md            # Deploy
│   ├── agents/
│   │   ├── investigator.md      # Investigar alertas
│   │   ├── ml-specialist.md     # Trabajo de ML
│   │   └── db-optimizer.md      # Optimización de DB
│   └── skills/
│       ├── sentinel-analyzer/
│       │   └── SKILL.md
│       └── blockchain-monitor/
│           └── SKILL.md
├── src/
│   └── ...
└── scripts/
    └── hooks/
        ├── validate_command.sh
        └── auto_format.sh
```

### Workflow Diario con Claude Code

```bash
# 1. Inicio del día - revisar estado
claude
> /review-alerts

# 2. Investigar una alerta específica
> Investiga la alerta #4521 del filtro B20. Usa el subagente investigator
  para analizar la wallet 0xabc123... y correlaciona con datos de mercado.

# 3. Implementar mejora en un filtro
> /new-feature Mejorar filtro W04 para reducir false positives cuando
  el volumen de transacciones es <5 en ventana de 24h

# 4. Code review antes de commit
> Usa el code-reviewer para revisar todos los cambios que hemos hecho hoy

# 5. Deploy
> /deploy
```

### MCP Específico para Sentinel

Tu `.mcp.json` ideal:

```json
{
  "mcpServers": {
    "sentinel-db": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://sentinel:pass@localhost:5432/sentinel_alpha"
      }
    },
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "alchemy": {
      "type": "stdio",
      "command": "python",
      "args": ["scripts/mcp/alchemy_server.py"],
      "env": {
        "ALCHEMY_API_KEY": "${ALCHEMY_KEY}"
      }
    }
  }
}
```

---

## 11. Caso Práctico: Web del Influencer / "Esto te interesa"

### Setup del Proyecto Web

```
esto-te-interesa/
├── CLAUDE.md
├── .claude/
│   ├── commands/
│   │   ├── new-video-script.md
│   │   ├── seo-optimize.md
│   │   └── thumbnail-brief.md
│   ├── agents/
│   │   ├── web-builder.md
│   │   ├── seo-specialist.md
│   │   └── content-writer.md
│   └── skills/
│       └── content-creator/
│           └── SKILL.md
├── src/                        # Código del sitio web
│   ├── pages/
│   ├── components/
│   └── styles/
├── content/                    # Scripts de videos, posts
│   ├── scripts/
│   └── blog/
└── assets/
```

### CLAUDE.md del Proyecto Web

```markdown
# Esto te interesa — Sitio Web + Canal YouTube

## Stack
- Framework: Astro (SSG) + React para componentes interactivos
- Estilos: Tailwind CSS
- Hosting: Vercel o Cloudflare Pages
- CMS: Archivos Markdown en /content

## Diseño
- Estética: moderna, limpia, dark mode por defecto
- Colores: fondo oscuro (#0a0a0a), acentos en azul (#3b82f6) y verde (#22c55e)
- Tipografía: Inter para texto, JetBrains Mono para código
- Inspiración: canales tech como Fireship, Linus Tech Tips

## Secciones del Sitio
1. Home: últimos videos + posts destacados
2. Videos: grid con thumbnails y descripciones
3. Blog: artículos en profundidad
4. Sobre mí: bio y links
5. Contacto: formulario simple

## SEO
- Cada página debe tener: title, description, og:image
- Sitemap generado automáticamente
- Schema.org markup para videos
```

### Slash Commands Creativos

**`.claude/commands/new-video-script.md`:**

```markdown
Crea un script de video para "Esto te interesa" sobre: $ARGUMENTS

Sigue la estructura de la skill content-creator.
Incluye:
1. Título SEO optimizado (3 opciones)
2. Descripción para YouTube
3. Tags sugeridos (15-20)
4. Script completo con timestamps
5. Notas para edición (B-roll sugerido, gráficos)
6. Ideas para thumbnail (3 conceptos)

Guarda el script en content/scripts/[fecha]-[slug].md
```

**`.claude/commands/seo-optimize.md`:**

```markdown
Analiza y optimiza el SEO de la página: $ARGUMENTS

1. Revisa meta tags (title, description, og:*)
2. Verifica estructura de headings (H1 > H2 > H3)
3. Comprueba alt text en imágenes
4. Analiza densidad de keywords
5. Verifica internal/external links
6. Sugiere mejoras concretas
```

---

## 12. Caso Práctico: Roblox Game Dev

### CLAUDE.md para el Proyecto Roblox

```markdown
# Roblox Crafting/Trading Simulator

## Concepto
Simulador de crafting y trading con raridades aleatorias
y progresión basada en dopamina loops.

## Stack
- Engine: Roblox Studio
- Lenguaje: Luau (Lua 5.1 + extensiones)
- Monetización: DevEx, Game Passes, Developer Products

## Mecánicas Core
- Sistema de crafting con recetas
- Raridades: Common (60%), Uncommon (25%), Rare (10%),
  Epic (4%), Legendary (1%)
- Trading entre jugadores con verificación anti-scam
- Daily rewards con escalado
- Seasonal events

## Convenciones Luau
- PascalCase para servicios y módulos
- camelCase para funciones y variables
- UPPER_CASE para constantes
- Documentar funciones públicas con --[[ ]]
```

---

## 13. Arquitectura Multi-Agente: Patrones Avanzados

### Patrón 1: Pipeline Secuencial

```
[Spec Writer] → [Architect] → [Implementer] → [Tester] → [Reviewer]
```

Cada agente produce output que alimenta al siguiente. Ideal para features nuevas en Sentinel Alpha.

### Patrón 2: Investigación en Paralelo

```
                 ┌── [Web Researcher]     ──┐
[Coordinador] →  ├── [Codebase Explorer]    ├── [Sintetizador]
                 └── [DB Analyst]           ──┘
```

Tres agentes investigan simultáneamente, un sintetizador combina resultados.

### Patrón 3: Master-Clone (Recomendado)

```
[Agente Principal]
  ├── Task(copia de sí mismo): "Investiga X"
  ├── Task(copia de sí mismo): "Analiza Y"
  └── Task(copia de sí mismo): "Revisa Z"
```

En lugar de crear subagentes especializados con prompts fijos, dejas que el agente principal delegue a copias de sí mismo con instrucciones específicas. Más flexible y menos frágil.

### Implementación con Claude CLI

```bash
# Pipeline en CI/CD con GitHub Actions
# El agente principal orquesta todo

claude -p "
  Analiza el PR #42 siguiendo este pipeline:
  1. Spawn un subagente para revisar seguridad
  2. Spawn otro para revisar rendimiento
  3. Spawn otro para verificar que los tests cubren los cambios
  4. Recoge los resultados y genera un review completo
  5. Si hay issues críticos, bloquea el merge
" --allowedTools "Read,Grep,Glob,Bash,Task"
```

### Uso de Pipes (Filosofía Unix)

Claude Code es composable:

```bash
# Analizar logs recientes
tail -200 logs/sentinel.log | claude -p "Busca anomalías y resúmelas"

# Review de cambios de git
git diff main --name-only | claude -p "Revisa estos archivos por security issues"

# Traducir strings
cat locales/en.json | claude -p "Traduce al español manteniendo las keys"

# Generar docs desde código
find src/ -name "*.py" | head -20 | claude -p "Genera documentación API para estos módulos"
```

---

## 14. CLI Avanzado y Trucos de Terminal

### Flags Útiles

```bash
# Ejecutar prompt directo sin modo interactivo
claude -p "explica qué hace el filtro B20"

# Continuar última sesión
claude --continue

# Reanudar sesión específica
claude --resume

# Usar modelo específico
claude --model claude-opus-4-6

# Limitar herramientas disponibles
claude --allowedTools "Read,Grep,Glob"

# Modo no interactivo (para scripts/CI)
claude -p "genera tests para src/filters/b20.py" --no-input

# Pipe de stdin
cat error.log | claude -p "diagnostica este error"
```

### Sesiones y Continuidad

```bash
# Iniciar sesión, trabajar, salir
claude
> ... trabajo ...
> /exit

# Continuar donde lo dejaste
claude --continue

# Ver sesiones anteriores y reanudar una específica
claude --resume
# Selecciona de la lista interactiva

# Resumir lo que un Claude anterior hizo (meta-debugging)
claude --resume
> Resume qué hicimos en esta sesión y qué problemas encontraste
```

### Integración con Git Worktrees

Para trabajar en múltiples features en paralelo:

```bash
# Crear worktree para una feature
git worktree add ../sentinel-feature-b32 feature/b32

# Lanzar Claude en ese worktree
cd ../sentinel-feature-b32
claude

# Mientras tanto, otro Claude en el worktree principal
cd ../sentinel-alpha
claude
```

---

## 15. Mejores Prácticas y Errores Comunes

### Mejores Prácticas

1. **CLAUDE.md es tu inversión más importante.** Dedica tiempo a escribirlo bien. Un buen CLAUDE.md ahorra horas de re-explicar cosas.

2. **Skills < 500 líneas.** Si tu SKILL.md crece demasiado, divídelo en archivos separados y referéncialos.

3. **Un subagente = una responsabilidad.** No hagas subagentes que hagan "todo". Dale a cada uno un objetivo claro.

4. **Hooks para lo determinista, Skills para lo probabilístico.** Si algo DEBE pasar siempre (formatear código), usa Hook. Si algo debe pasar "cuando tenga sentido" (aplicar un patrón de diseño), usa Skill.

5. **Empieza simple, escala según necesidad:**
   - Semana 1: Solo CLAUDE.md + uso básico
   - Semana 2: Añade 2-3 Slash Commands
   - Semana 3: Configura 1-2 MCP servers
   - Semana 4: Crea tu primera Skill
   - Semana 5+: Subagentes y Hooks según necesites

6. **Usa `--continue` religiosamente.** No pierdas contexto entre sesiones.

7. **Versiona todo en git:** CLAUDE.md, commands, agents, skills, hooks. Tu configuración de Claude Code ES parte del proyecto.

8. **Scope herramientas por agente.** Si un subagente no necesita Write, no se lo des. Principio de mínimo privilegio.

### Errores Comunes

| Error | Solución |
|-------|----------|
| CLAUDE.md demasiado largo (>15KB) | Mueve expertise a Skills, deja solo lo esencial |
| Subagentes con todos los tools | Especifica `tools:` explícitamente en el frontmatter |
| MCP server no conecta | Verifica paths, env vars, y que el paquete npm está instalado |
| Hooks no se ejecutan | Verifica el matcher (es regex), paths con `$CLAUDE_PROJECT_DIR` |
| Contexto se llena rápido | Usa subagentes para tareas pesadas, `/compact` para limpiar |
| Resultados inconsistentes | Sé más específico en el CLAUDE.md, añade ejemplos concretos |
| Skill no se activa | Mejora la `description` en el frontmatter — es lo que Claude lee |

### Debugging

```bash
# Ver qué herramientas y MCP están disponibles
> /tools

# Ver agentes disponibles
> /agents

# Compactar contexto cuando se llena
> /compact

# Ver memoria auto-generada
> /memory

# Ver configuración activa
> /config
```

---

## 16. Recursos y Referencias

### Documentación Oficial

- **Claude Code Docs:** https://code.claude.com/docs/en/overview
- **Agent Skills:** https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- **MCP en Agent SDK:** https://platform.claude.com/docs/en/agent-sdk/mcp
- **Hooks:** https://platform.claude.com/docs/en/agent-sdk/hooks
- **Subagentes:** https://code.claude.com/docs/en/sub-agents
- **npm Package:** https://www.npmjs.com/package/@anthropic-ai/claude-code

### Blog Posts Clave

- **Skills Explained (Anthropic):** https://claude.com/blog/skills-explained
- **Equipping Agents with Skills:** https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
- **Full Stack Guide:** https://alexop.dev/posts/understanding-claude-code-full-stack/
- **Best Practices Subagents (PubNub):** https://www.pubnub.com/blog/best-practices-for-claude-code-sub-agents/

### Repos de Referencia

- **Hooks Mastery:** https://github.com/disler/claude-code-hooks-mastery
- **Awesome Claude Code:** buscar "awesome-claude-code" en GitHub

### Servidores MCP Populares

- **Lista oficial:** https://github.com/modelcontextprotocol/servers
- **Directorio MCP:** buscar "MCP server directory" para ver la lista completa y actualizada

---

## Cheat Sheet Rápido

```
┌────────────────────────────────────────────────────────┐
│                CLAUDE CODE CHEAT SHEET                  │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ARCHIVOS DE CONFIG                                    │
│  CLAUDE.md          → Contexto permanente del proyecto │
│  .mcp.json          → Servidores MCP                   │
│  .claude/settings   → Hooks y preferencias             │
│  .claude/commands/  → Slash commands                   │
│  .claude/agents/    → Subagentes                       │
│  .claude/skills/    → Skills del proyecto              │
│                                                        │
│  COMANDOS RÁPIDOS                                      │
│  /compact           → Limpiar contexto                 │
│  /tools             → Ver herramientas disponibles     │
│  /agents            → Gestionar subagentes             │
│  /memory            → Ver auto-memoria                 │
│  /config            → Ver configuración                │
│  /plugins           → Gestionar plugins                │
│                                                        │
│  CLI                                                   │
│  claude -p "..."    → Prompt directo                   │
│  claude --continue  → Continuar última sesión          │
│  claude --resume    → Reanudar sesión específica       │
│  cat X | claude -p  → Pipe de stdin                    │
│                                                        │
│  JERARQUÍA DE ACTIVACIÓN                               │
│  CLAUDE.md    → Siempre cargado (estático)             │
│  Skills       → Auto-activadas por contexto            │
│  Commands     → Activación manual (/nombre)            │
│  Hooks        → Automáticos por evento (determinista)  │
│  Subagentes   → Delegados por el agente principal      │
│  MCP          → Conexiones externas siempre disponibles│
│                                                        │
└────────────────────────────────────────────────────────┘
```

---

> **Nota final:** Esta guía está basada en la documentación oficial y mejores prácticas de la comunidad a fecha de marzo 2026. Claude Code evoluciona rápidamente — consulta siempre la documentación oficial en https://code.claude.com/docs para la información más actualizada.
