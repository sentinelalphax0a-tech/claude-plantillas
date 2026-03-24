---
name: sentinel-analyzer
description: >
  Analiza alertas de insider trading en Sentinel Alpha. Usa cuando el
  usuario pida analizar wallets, revisar alertas, ejecutar filtros,
  diagnosticar false positives, o generar reportes del sistema de detección.
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Sentinel Analyzer Skill

## Cuándo usar
- Análisis de wallets sospechosas
- Revisión de alertas por filtro
- Diagnóstico de false positives
- Generación de reportes de actividad
- Evaluación de nuevos filtros

## Workflow de análisis rápido

### 1. Analizar wallet
```bash
python scripts/analyze_wallet.py --address <wallet_address>
```
Devuelve: puntuación de estrellas, mercados participados,
markets_won/markets_lost, agrupaciones union-find.

### 2. Revisar alertas por filtro
```bash
python scripts/generate_report.py --filter B20 --hours 24
```

### 3. Limpiar false positives conocidos
```bash
python scripts/cleaner_post_deep.py
```

## Criterios de false positive por filtro

| Filtro | Criterio de FP | Verificación |
|--------|----------------|--------------|
| W04/W05 | Volumen orgánico | >10 txs distribuidas en >6 horas |
| B20 | Wallet legítima | >30 días de actividad previa |
| B23/B28 | Evento de mercado | Correlacionar con noticias/eventos conocidos |
| N06 | Market maker | Verificar si es market maker conocido |
| W09 | Patrón normal | Comparar con baseline de actividad del mercado |

## Formato de reporte estándar

| Wallet | Estrellas | Filtro | Mercado | Clasificación | Acción |
|--------|-----------|--------|---------|---------------|--------|
| 0x... | ⭐⭐⭐ | B20 | ... | TP/FP/INC | ... |

## Notas
- B32 (repeat-performance) NO activo aún — target Q1 2027
- Mín 5-7 apariciones por wallet para significancia estadística
- Union-find: no tocar sin tests de regresión
- PostgreSQL: paginar queries de agrupación >10K wallets
