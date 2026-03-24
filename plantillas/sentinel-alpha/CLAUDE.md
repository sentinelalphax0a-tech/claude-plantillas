# Sentinel Alpha — Sistema de Detección de Insider Trading

## Descripción
Sentinel Alpha (antes Sentinel Beta) detecta insider trading en mercados
de predicción como Polymarket. Monitoriza transacciones blockchain, puntúa
comportamientos sospechosos de wallets con sistema de estrellas (1-5), y usa
algoritmos union-find para agrupación de wallets relacionadas.

## Stack Tecnológico
- Backend: Python 3.11+, FastAPI
- Base de datos: PostgreSQL con pgvector
- Blockchain: Web3.py, Alchemy API
- Frontend Dashboard: React + Tailwind CSS
- ML: Arquitectura dual (ML1 detección insiders, ML2 correlación cross-market)
- Infraestructura: Mac Mini M4, 32GB RAM, 4TB SSD externo

## Convenciones de Código
- PEP 8 estricto (ruff + black)
- Type hints obligatorios
- Docstrings en español para funciones públicas
- Variables/funciones en inglés, comentarios en español
- Commits: inglés, `feat:`, `fix:`, `refactor:`, `docs:`

## Estructura del Proyecto
```
sentinel-alpha/
├── src/
│   ├── ml1/              # Modelo ML1: detección de insiders
│   ├── ml2/              # Modelo ML2: correlación cross-market
│   ├── filters/          # Filtros: W04, W05, W09, B20, B23, B28, N06, B32
│   ├── blockchain/       # Conexión a Polymarket/blockchain
│   ├── dashboard/        # React dashboard público
│   └── utils/            # Utilidades comunes
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
- Alertas con sistema 1-5 estrellas para severidad
- Filtro B32 (wallet repeat-performance): requiere mín 5-7 apariciones
  por wallet para significancia estadística. Apuntado para ~Q1 2027
  cuando haya ~8K-10K resolved alerts. Usará markets_won/markets_lost
  de la tabla wallets. También será ML feature para meta-labeling model.
- Union-find agrupa wallets relacionadas → NUNCA modificar el algoritmo
  sin revisar tests de regresión completos
- Dashboard: autenticación por URL-parameter (temporal)

## Notas de Debugging
- False positives comunes en W04/W05 → ejecutar cleaner_post_deep.py
- Si scraper blockchain falla → verificar API key de Alchemy
- PostgreSQL se bloquea con queries de agrupación >10K wallets → paginar
- W09 tiende a false positives con market makers legítimos
- B23/B28: correlacionar siempre con eventos de mercado conocidos

## Estado Actual
- En progreso: Refinamiento de filtros, reducción de false positives
- Pendiente: Dashboard público, filtro B32, modelo ML2
- Monetización planificada: suscripciones tiered, posible venta de IP
