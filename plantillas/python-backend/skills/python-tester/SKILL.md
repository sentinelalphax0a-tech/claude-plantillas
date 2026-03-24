---
name: python-tester
description: >
  Genera y ejecuta tests para código Python. Usa cuando el usuario pida
  escribir tests, mejorar cobertura, o cuando se añada código nuevo que
  necesite testing. Usa pytest con fixtures, parametrize, y mocking.
allowed-tools: Read, Write, Bash, Grep, Glob
---

# Python Testing Skill

## Convenciones de testing
- Framework: pytest
- Fixtures en `conftest.py` (compartidos) o en el archivo de test
- Mocking con `unittest.mock` o `pytest-mock`
- Tests async con `pytest-asyncio`
- Nombrar: `test_[función]_[escenario]_[resultado_esperado]`

## Workflow
1. Identifica la función/clase a testear
2. Lee el código fuente para entender inputs, outputs, side effects
3. Genera tests cubriendo:
   - Happy path (caso normal)
   - Edge cases (vacío, None, límites)
   - Error cases (excepciones esperadas)
4. Ejecuta: `pytest [archivo] -v --tb=short`
5. Ajusta si fallan

## Patrones preferidos
```python
# Parametrize para múltiples inputs
@pytest.mark.parametrize("input,expected", [
    ("caso_1", resultado_1),
    ("caso_2", resultado_2),
])
def test_funcion(input, expected):
    assert funcion(input) == expected

# Fixtures para setup complejo
@pytest.fixture
def db_session():
    session = create_test_session()
    yield session
    session.rollback()

# Testing de excepciones
def test_funcion_error():
    with pytest.raises(ValueError, match="mensaje esperado"):
        funcion(input_invalido)
```

## Anti-patrones a evitar
- Tests que dependen de orden de ejecución
- Tests que dependen de estado externo (DB real, APIs)
- Tests con sleep() — usar mocking
- Tests que prueban implementación en vez de comportamiento
