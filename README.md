# Robot Framework Selenium Automation - Wayni (Préstamos)

Este proyecto automatiza un flujo representativo del sitio de Wayni, específicamente en la web de préstamos: https://app.waynimovil.ar/prestamos usando Robot Framework y SeleniumLibrary. El caso principal simula el inicio del proceso de solicitud con datos controlados, acepta TyC (formulario + modal) y detecta el outcome final por URL, validando la pantalla de “sin oferta” cuando corresponde.

Nota (alcance del examen): se solicitó ejecutar end to end en entorno local usando los flujos de https://app.waynimovil.ar/prestamos y https://autogestion.waynimovil.ar/. Este repo cubre end to end el flujo de préstamos y deja lista la arquitectura para extender a “autogestión”.

## Estructura del proyecto

- registro_wayni_prestamos.robot: Caso de prueba principal, declarativo y parametrizable por banco/fecha/email/DNI.
- keywords.robot: Keywords reutilizables que encapsulan la lógica: apertura de navegador con opciones, inputs robustos, selección de banco (combobox HeadlessUI), TyC (form + modal) con fallbacks cross-browser y detección de outcome final por URL.
- locators.robot: XPaths centralizados, incluyendo plantillas case-insensitive con soporte de acentos y alternativas para elementos dinámicos.
- variables.py: Variables globales (URL, mapping de navegadores).
- Reportes y capturas: Robot Framework genera report.html, log.html y screenshots en la carpeta de salida.

## Flujo cubierto

1. Apertura de https://app.waynimovil.ar/prestamos en Chrome o Firefox, bloqueando notificaciones y popups para estabilidad.
2. Completar DNI, celular, banco (desde combobox con búsqueda y selección), fecha de nacimiento y email.
3. Aceptar TyC en formulario y en modal emergente (manejos específicos para Firefox/Chrome).
4. Continuar y sincronizar por URL hasta determinar el resultado:
   - Sin oferta: validar la pantalla de “sin oferta”.
   - Éxito: placeholder por patrón de URL (ajustable según negocio).

## Requisitos

- Python 3.9+ (recomendado 3.10/3.11)
- Google Chrome y/o Mozilla Firefox instalados
- pip y venv
- Selenium 4.6+ (recomendado para usar Selenium Manager y evitar drivers manuales)

## Instalación

```bash
# 1) Crear y activar entorno virtual
python3 -m venv venv
source venv/bin/activate  # macOS/Linux
# .\venv\Scripts\activate  # Windows PowerShell

# 2) Instalar dependencias
pip install --upgrade pip
pip install robotframework selenium robotframework-seleniumlibrary

/////////////
Ejecución
bash
Copy
# Ejecutar registro
robot -d results registro_wayni_prestamos.robot
# Ejecutar Autogestión
robot -d results_autog test_wayni_autogestion.robot

El test por defecto abre Chrome (CH) porque el caso lo invoca con ese parámetro. Para ejecutar en Firefox cambia “CH” por “FX” en el test o crea un segundo test case con “FX”.
Para limpiar resultados previos: elimina/renombra la carpeta “results” antes de correr o usa otra con -d.
Decisiones técnicas y justificación
A continuación, un resumen claro y preciso de las decisiones tomadas.

Locators centralizados (locators.robot): se evitan duplicaciones y se facilita el mantenimiento ante cambios de UI. Se incluyen plantillas case-insensitive con soporte de acentos para robustecer matching por texto en español.

Selección de banco en combobox HeadlessUI: se contemplan varias estrategias (abrir por id/role/svg-icon, búsqueda en input, polling con retries, y fallback por teclado) para tolerar render asíncrono y diferencias entre Chrome y Firefox.

TyC robusto (form + modal): se marca el checkbox del formulario y se maneja el modal con múltiples locators scopeados al propio modal, más un fallback con JavaScript click si el navegador (típicamente Firefox) no propaga correctamente el evento.

Manejo de consent/banners: keyword dedicada que intenta cerrar banners comunes por texto/categorías, evitando fallas intermitentes por overlays.

Normalización de fecha: se normalizan separadores (guiones → barras), se dispara validación con TAB y se valida el valor de forma tolerante a máscaras del input.

Multi‑navegador: drivers creados con opciones específicas (Chrome: desactivar notificaciones; Firefox: modo privado y bloqueo de web notifications) para reducir ruido entre ejecuciones.

Sincronización por URL (“Detect outcome”): patrón claro y rápido para determinar el estado final sin acoplarse a detalles internos de la UI.

Hover antes de click en Autogestión: el botón “Continuar” requiere hover previo para aplicar estilos/estado, por eso se incluye Mouse Over antes de Click Element.

Parametrización simple y reuso: los casos invocan keywords con argumentos (DNI, banco, email, fecha, navegador), habilitando combinatorias y predefinición de escenarios para regresión e individuales.

Comentario unificado (razón de arquitectura):

Código escalable y reutilizable orientado a reuso y parametrización: permite combinar distintos logins (emails, DNI, fechas y bancos) y dejar casos predefinidos; además, facilita mantener tests de regresión con datos fijos a propósito y, en pocos minutos, crear tests individuales con características específicas para pruebas puntuales.

Estructura del proyecto

registro_wayni_prestamos.robot: suite principal del flujo de Préstamos.

test_wayni_autogestion.robot: suite del flujo de Autogestión.

keywords.robot: implementación de keywords reutilizables para ambos flujos (apertura de navegador, inputs, selección de banco, TyC, sincronización por URL, etc.).

locators.robot: variables y localizadores centralizados (XPaths, URLs, diccionarios, plantillas de XPath).

results/, report.html, log.html: artefactos de ejecución generados por Robot.

Troubleshooting
Gatekeeper bloquea chromedriver en macOS: quitar atributo de cuarentena con xattr -dr com.apple.quarantine /opt/homebrew/bin/chromedriver (o la ruta que arroje which chromedriver). Si Selenium usa su caché: xattr -dr com.apple.quarantine ~/.cache/selenium.

Driver/version warnings: con Selenium ≥ 4.6 conviene no fijar drivers locales; remover chromedriver/geckodriver del PATH y dejar que Selenium Manager los resuelva.

Firefox no hace click en “Continuar” del modal: ya se incluyen scroll, hover, enabled y fallback JS. Si persiste, revisar capturas en log.html y aumentar timeouts en Wait Until Page Contains Element y Wait Until Element Is Enabled.

La máscara de fecha cambia separador: está contemplado; si necesitas aserción estricta, ajustar la keyword Imput birthday para leer y normalizar el value antes de comparar.

Licencia
Uso interno/ Ajustar según políticas que necesite la organizacion.