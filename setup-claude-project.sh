#!/bin/bash
# setup-claude-project.sh — Configura un proyecto nuevo con templates de Claude Code
# Uso: ./setup-claude-project.sh <tipo> <ruta-proyecto>
# Tipos: python-backend, web-frontend, roblox-luau, sentinel-alpha, youtube-content

set -e

TEMPLATES_DIR="$(cd "$(dirname "$0")" && pwd)"
TYPE="$1"
PROJECT_DIR="$2"

if [ -z "$TYPE" ] || [ -z "$PROJECT_DIR" ]; then
    echo "Uso: $0 <tipo> <ruta-proyecto>"
    echo ""
    echo "Tipos disponibles:"
    echo "  python-backend   — Proyectos Python (FastAPI, Django, scripts)"
    echo "  web-frontend     — Proyectos web (React, Astro, Next.js)"
    echo "  roblox-luau      — Desarrollo Roblox"
    echo "  sentinel-alpha   — Sentinel Alpha (configuración específica)"
    echo "  youtube-content  — Canal 'Esto te interesa'"
    exit 1
fi

if [ ! -d "$TEMPLATES_DIR/$TYPE" ]; then
    echo "Error: Tipo '$TYPE' no encontrado en $TEMPLATES_DIR/"
    exit 1
fi

echo "🔧 Configurando proyecto '$TYPE' en $PROJECT_DIR..."

# Crear directorio .claude si no existe
mkdir -p "$PROJECT_DIR/.claude"/{skills,agents}

# Copiar templates base
echo "  📋 Copiando templates base..."
if [ -d "$TEMPLATES_DIR/_base/skills" ]; then
    cp -rn "$TEMPLATES_DIR/_base/skills/"* "$PROJECT_DIR/.claude/skills/" 2>/dev/null || true
fi
if [ -d "$TEMPLATES_DIR/_base/agents" ]; then
    cp -rn "$TEMPLATES_DIR/_base/agents/"* "$PROJECT_DIR/.claude/agents/" 2>/dev/null || true
fi
if [ -f "$TEMPLATES_DIR/_base/hooks/settings.json" ] && [ ! -f "$PROJECT_DIR/.claude/settings.json" ]; then
    cp "$TEMPLATES_DIR/_base/hooks/settings.json" "$PROJECT_DIR/.claude/settings.json"
fi

# Copiar templates específicos del tipo
echo "  📋 Copiando templates de $TYPE..."
if [ -d "$TEMPLATES_DIR/$TYPE/skills" ]; then
    cp -rn "$TEMPLATES_DIR/$TYPE/skills/"* "$PROJECT_DIR/.claude/skills/" 2>/dev/null || true
fi
if [ -d "$TEMPLATES_DIR/$TYPE/agents" ]; then
    cp -rn "$TEMPLATES_DIR/$TYPE/agents/"* "$PROJECT_DIR/.claude/agents/" 2>/dev/null || true
fi

# Hooks: mergear o copiar (el específico sobreescribe al base)
if [ -f "$TEMPLATES_DIR/$TYPE/hooks/settings.json" ]; then
    echo "  ⚙️  Copiando hooks de $TYPE (sobreescribe hooks base)..."
    cp "$TEMPLATES_DIR/$TYPE/hooks/settings.json" "$PROJECT_DIR/.claude/settings.json"
fi

# MCP config si existe
if [ -f "$TEMPLATES_DIR/$TYPE/.mcp.json" ] && [ ! -f "$PROJECT_DIR/.mcp.json" ]; then
    echo "  🔌 Copiando configuración MCP..."
    cp "$TEMPLATES_DIR/$TYPE/.mcp.json" "$PROJECT_DIR/.mcp.json"
fi

# CLAUDE.md template
if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
    if [ -f "$TEMPLATES_DIR/$TYPE/CLAUDE.md" ]; then
        echo "  📝 Copiando CLAUDE.md listo para usar..."
        cp "$TEMPLATES_DIR/$TYPE/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
    elif [ -f "$TEMPLATES_DIR/$TYPE/CLAUDE.md.template" ]; then
        echo "  📝 Copiando CLAUDE.md template (editar manualmente)..."
        cp "$TEMPLATES_DIR/$TYPE/CLAUDE.md.template" "$PROJECT_DIR/CLAUDE.md"
    fi
fi

echo ""
echo "✅ Proyecto configurado. Estructura:"
find "$PROJECT_DIR/.claude" -type f | sort | sed "s|$PROJECT_DIR/||"
[ -f "$PROJECT_DIR/CLAUDE.md" ] && echo "CLAUDE.md"
[ -f "$PROJECT_DIR/.mcp.json" ] && echo ".mcp.json"
echo ""
echo "📌 Próximos pasos:"
echo "  1. Edita CLAUDE.md con los datos reales del proyecto"
echo "  2. Revisa .claude/settings.json y ajusta hooks"
echo "  3. Configura .mcp.json con tus API keys"
echo "  4. cd $PROJECT_DIR && claude"
