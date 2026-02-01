*** Settings ***
Resource          ../resources/keywords.robot
Variables         ../resources/variables.py
Test Teardown     Finalizar Test Y Capturar Evidencia

*** Test Cases ***

# --- EJERCICIO 1: VALIDACIONES DE NAVEGACIÓN ---

Test 1: Ruta Especifica Construccion
    [Documentation]    Valida la navegación profunda en la categoría Construcción.
    Abrir Navegador En Mercado Libre       Chrome
    Navegar Hacia Categoria Inteligente    Construcción
    Hacer Clic En Enlace De Texto          Baños y Sanitarios
    Hacer Clic En Enlace De Texto          Grifería para Baño
    Wait Until Page Contains               Grifería    15s

Test 2: Navegacion Lateral (Padre-Hijo)
    [Documentation]    Valida el menú desplegable de categorías (Hover).
    Abrir Navegador En Mercado Libre       Chrome
    Navegar Por Subcategoria Lateral       Tecnología    Accesorios para Celulares

Test 3: Ofertas del Dia
    [Documentation]    Verifica el acceso directo a la sección de Ofertas.
    Abrir Navegador En Mercado Libre       Chrome
    Ejecutar Flujo Ofertas Del Dia

# Los Test 4 y 4.1 permiten probar la búsqueda en las dos verticales de Supermercado
# Parámetros: [Camino (carrefour/full super)] | [Producto a buscar]
Test 4: Supermercado - Camino Carrefour
    Abrir Navegador En Mercado Libre       Chrome
    Ejecutar Busqueda Supermercado         carrefour    capsulas

Test 4.1: Supermercado - Camino Full Super
    Abrir Navegador En Mercado Libre       Chrome
    Ejecutar Busqueda Supermercado         full super    capsulas

# --- EJERCICIO 2: CUANTIFICACIÓN Y FILTROS ---

Test 6: Cuantificador de categoria
    [Documentation]    Extrae la cantidad total de productos en una categoría específica.
    [Setup]    Abrir Navegador En Mercado Libre    Chrome
    Cuantificador de categoria    Construcción

Test 7: Parametrizador de categoria por precio
    [Documentation]    Aplica filtros de precio y reutiliza la lógica de cuantificación.
    # PARÁMETROS MODIFICABLES: Puedes cambiar los valores 100 y 50000 para probar distintos rangos
    [Setup]    Abrir Navegador En Mercado Libre    Chrome
    Navegar Hacia Categoria Inteligente    Construcción
    Parametrizador de precio para categoria    100    50000