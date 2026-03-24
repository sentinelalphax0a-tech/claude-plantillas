# Claude Code Templates — Sistema de Configuración por Proyecto

> **Autor:** Alex — Ingeniería Informática USAL
> **Última actualización:** Marzo 2026

## Estructura

```
claude-code-templates/
├── _base/                    # Templates base (copiar a cada proyecto nuevo)
│   ├── CLAUDE.md.template    # CLAUDE.md genérico — rellenar por proyecto
│   ├── global-CLAUDE.md      # Para ~/.claude/CLAUDE.md (preferencias globales)
│   ├── skills/
│   │   └── code-reviewer/SKILL.md
│   ├── agents/
│   │   └── code-reviewer.md
│   └── hooks/
│       └── settings.json     # Hooks base (auto-format, seguridad)
│
├── python-backend/           # Para proyectos Python (FastAPI, Django, scripts)
├── web-frontend/             # Para proyectos web (React, Astro, HTML/CSS/JS)
├── roblox-luau/              # Para desarrollo Roblox
├── sentinel-alpha/           # Configuración específica de Sentinel
└── youtube-content/          # Para "Esto te interesa" y content creation
```

## Cómo usar

### Proyecto nuevo
1. Copia `_base/` a tu proyecto como `.claude/`
2. Copia el template de tipo de proyecto relevante y mergea
3. Rellena `CLAUDE.md.template` → renombra a `CLAUDE.md`
4. Ajusta hooks y MCP según necesidad

### Ejemplo rápido
```bash
# Nuevo proyecto Python
cp -r claude-code-templates/_base/.  mi-proyecto/.claude/
cp -r claude-code-templates/python-backend/.  mi-proyecto/.claude/
cp claude-code-templates/_base/CLAUDE.md.template mi-proyecto/CLAUDE.md
# Edita CLAUDE.md con los datos del proyecto
```

## Notas importantes
- **Commands y Skills están unificados** desde 2025. Usa `.claude/skills/` para todo.
- **Frontmatter** en SKILL.md es obligatorio: `name` y `description` mínimo.
- **Progressive Disclosure**: solo se carga el frontmatter por defecto; SKILL.md completo solo cuando Claude lo necesita.
- Skills en `~/.claude/skills/` son globales (todos tus proyectos).
- Skills en `.claude/skills/` son del proyecto (compartibles via git).
