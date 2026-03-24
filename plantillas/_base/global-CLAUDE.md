# Preferencias Globales de Alex

## Idioma
- Código: variables y funciones en inglés
- Comentarios y documentación: español
- Commits: inglés, formato convencional: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`
- Mensajes de error y logs: inglés

## Estilo de comunicación
- Sé directo y conciso
- Usa analogías cuando expliques conceptos nuevos
- Si hay múltiples enfoques, presenta los 2 mejores con pros/contras
- Cuando edites código, explica el porqué del cambio en un comentario breve

## Herramientas preferidas
- Python: `ruff` para linting, `black` para formato, `pytest` para tests
- JavaScript/TypeScript: `prettier` + `eslint`, `vitest` para tests
- Git: commits atómicos, nunca commit sin tests pasando
- Editor: VS Code

## Convenciones generales
- Type hints obligatorios en Python
- TypeScript estricto (no `any`)
- Funciones <30 líneas, una responsabilidad
- Manejo de errores explícito (no silenciar excepciones)
- Documentar funciones públicas siempre

## No hacer nunca
- No commitear credenciales, API keys, o secretos
- No usar `rm -rf` en producción
- No modificar base de datos de producción sin confirmación
- No instalar dependencias sin justificación
