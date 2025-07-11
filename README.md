# Robot Framework Selenium Automation - SauceDemo

Este proyecto automatiza pruebas sobre la web [SauceDemo](https://www.saucedemo.com/) usando Robot Framework y SeleniumLibrary.  
Incluye validaciones de login, agregado y remoción de productos al carrito, logout y una consulta a la API de MercadoLibre.

## Estructura del proyecto

- `login_souce.robot`: Casos de prueba principales.
- `keywords.robot`: Keywords reutilizables para acciones comunes.
- `locators.robot` y `variables.py`: Variables y XPaths centralizados.
- Capturas de pantalla y reportes se generan automáticamente tras cada test.

## Casos de prueba cubiertos

1. Login y agregado de 1 a 6 productos al carrito, limpieza y logout.
2. Login con usuarios especiales (locked, problem, glitch, error, visual).
3. Consulta a la API de MercadoLibre y validación de departamentos.
4. Casos de test configurables: puedes cambiar productos, usuarios y navegador fácilmente.

## Requisitos

- Python 3.8+
- pip

## Instalación de dependencias

```bash
pip install robotframework selenium robotframework-seleniumlibrary robotframework-requests