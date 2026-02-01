# 🛒 Mercado Libre Automation Suite - Robot Framework

Este proyecto contiene una suite de pruebas automatizadas para Mercado Libre Argentina. Se enfoca en la validación de componentes globales, navegación por categorías y el uso de filtros avanzados mediante técnicas de manipulación de URLs y scrolls dinámicos.

---

## 📂 Estructura del Proyecto

* `tests/`: Casos de prueba (.robot).
* `resources/`: Keywords, Locators y Variables.
* `results/`: Evidencias de ejecución (Capturas y reportes).
* `requirements.txt`: Dependencias del sistema.

---

## 🛠️ Instalación y Configuración (Universal)

Sigue estos pasos para ejecutar las pruebas en Windows, Mac o Linux:

### 1. Clonar el repositorio
```bash
git clone <TU_URL_DE_REPOSITORIO>
cd <NOMBRE_DE_TU_CARPETA>

## 🚀 Cómo ejecutar la Suite Completa

Para garantizar la integridad del sistema, se recomienda ejecutar todos los tests en secuencia. Esto permite observar el flujo completo desde las validaciones globales hasta la lógica compleja de filtrado.

### 1. Ejecución estándar
Abre tu terminal en la raíz del proyecto y ejecuta:

```bash
robot -d results tests/mercadolibre_test.robot