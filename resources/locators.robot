*** Variables ***
# ====================================================================
# --- 1. ELEMENTOS GLOBALES (Configuración y Home) ---
# ====================================================================
# Estos elementos se utilizan en la mayoría de los tests para validaciones base.

${CSS_LOGO_ML}            css:a.nav-logo
${CSS_BTN_CATEGORIAS}     css:a.nav-menu-categories-link
${CSS_COOKIES_BANNER}     css:.cookie-consent-banner-opt-out__container
${INPUT_BUSCADOR}         id:cb1-edit


# ====================================================================
# --- 2. LOGICA EJERCICIO 1 (Navegación y Búsqueda) ---
# ====================================================================

# Templates Dinámicos: permiten inyectar texto para localizar elementos variables
${TEMPLATE_MENU_ITEM}     xpath://div[contains(@class, 'nav-categs')]//a[text()='REPLACE_TEXT']
${TEMPLATE_MENU_PADRE}    xpath://div[contains(@class, 'nav-categs')]//a[text()='REPLACE_PADRE']
${TEMPLATE_MENU_HIJO}     xpath://div[contains(@class, 'nav-categs')]//a[text()='REPLACE_HIJO']
${TEMPLATE_LINK_TEXTO}    xpath://a[contains(normalize-space(),'REPLACE_TEXT')]

# Navegación Específica
${XPATH_NAV_OFERTAS}      xpath://ul[@class='nav-menu-list']//a[text()='Ofertas']


# ====================================================================
# --- 3. LOGICA EJERCICIO 2 (Cuantificación y Filtros) ---
# ====================================================================

# Cuantificación: Usado en Test 6 y Test 7 para extraer el número de productos
${TXT_CANTIDAD_RESULTADOS}    xpath://span[contains(@class, 'quantity-result')]

# Elementos de la Barra Lateral y Filtros de Precio
${BARRA_LATERAL}              xpath://aside[@id='filters']
${TITULO_PRECIO}              xpath://h3[contains(normalize-space(),'Precio')]

# Locators de Seguridad para Inputs de Precio
# Nota: Se usan XPaths combinados (|) para asegurar que el test no falle si ML cambia el atributo id o name
${INPUT_PRECIO_MIN}    xpath://input[@data-testid='Minimum-Price'] | //input[contains(@name, 'Minimum')] | //label[contains(.,'Mínimo')]/input
${INPUT_PRECIO_MAX}    xpath://input[@data-testid='Maximum-Price'] | //input[contains(@name, 'Maximum')] | //label[contains(.,'Máximo')]/input
${BTN_APLICAR_PRECIO}  xpath://button[@data-testid='submit-price']