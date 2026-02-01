*** Settings ***
Library    SeleniumLibrary
Library    String
Library    web_manager.py
Resource   locators.robot
Variables  variables.py

*** Keywords ***
# ====================================================================
# --- 1. CONFIGURACIÓN Y UTILIDADES GLOBALES ---
# ====================================================================

Abrir Navegador En Mercado Libre
    [Arguments]    ${browser}
    [Documentation]    Configuración inicial del entorno y el driver.
    ${driver_path}=    Get Chromedriver Path
    ${service}=    Evaluate    sys.modules['selenium.webdriver.chrome.service'].Service(executable_path=r'${driver_path}')    sys, selenium.webdriver.chrome.service
    Set Screenshot Directory    ${EVIDENCIAS_DIR}
    Create Webdriver    ${browser}    service=${service}
    Maximize Browser Window
    Go To    ${URL_ML}
    Wait Until Element Is Visible    ${CSS_LOGO_ML}    15s
    Eliminar Cookies Si Existen

Eliminar Cookies Si Existen
    [Documentation]    Limpia el banner de cookies mediante JS para evitar interrupciones.
    ${presente}=    Run Keyword And Return Status    Element Should Be Visible    ${CSS_COOKIES_BANNER}    5s
    IF    ${presente}
        Execute JavaScript    if(document.querySelector('.cookie-consent-banner-opt-out__container')) document.querySelector('.cookie-consent-banner-opt-out__container').remove()
    END

Finalizar Test Y Capturar Evidencia
    [Documentation]    Cierre de sesión y guardado de captura con el nombre del test ejecutado.
    ${nombre_limpio}=    Replace String    ${TEST_NAME}    ${SPACE}    _
    Capture Page Screenshot    ${nombre_limpio}.png
    Log To Console    \n[EVIDENCIA] Captura guardada: ${nombre_limpio}.png
    Close Browser


# ====================================================================
# --- 2. LOGICA EJERCICIO 1 (Tests 1, 2, 3, 4 y 4.1) ---
# ====================================================================

Navegar Hacia Categoria Inteligente
    [Arguments]    ${nombre_categoria}
    [Documentation]    Acciona el menú de categorías y selecciona la opción deseada.
    Wait Until Element Is Visible    ${CSS_BTN_CATEGORIAS}    10s
    Mouse Over    ${CSS_BTN_CATEGORIAS}
    ${xpath}=    Replace String    ${TEMPLATE_MENU_ITEM}    REPLACE_TEXT    ${nombre_categoria}
    Wait Until Element Is Visible    ${xpath}    10s
    Click Element    ${xpath}

Hacer Clic En Enlace De Texto
    [Arguments]    ${texto}
    [Documentation]    Busca y scrollea hacia un enlace basado en su contenido de texto.
    ${xpath}=    Replace String    ${TEMPLATE_LINK_TEXTO}    REPLACE_TEXT    ${texto}
    Wait Until Element Is Visible    ${xpath}    15s
    Scroll Element Into View    ${xpath}
    Click Element    ${xpath}

Navegar Por Subcategoria Lateral
    [Arguments]    ${categoria_padre}    ${subcategoria_hijo}
    [Documentation]    Navegación jerárquica (Hover sobre padre -> Clic en hijo).
    Wait Until Element Is Visible    ${CSS_BTN_CATEGORIAS}    10s
    Mouse Over    ${CSS_BTN_CATEGORIAS}
    ${xpath_p}=    Replace String    ${TEMPLATE_MENU_PADRE}    REPLACE_PADRE    ${categoria_padre}
    Mouse Over    ${xpath_p}
    ${xpath_h}=    Replace String    ${TEMPLATE_MENU_HIJO}    REPLACE_HIJO    ${subcategoria_hijo}
    Wait Until Element Is Visible    ${xpath_h}    10s
    Click Element    ${xpath_h}

Ejecutar Flujo Ofertas Del Dia
    [Documentation]    Acceso y validación de la landing de ofertas.
    Wait Until Element Is Visible    ${XPATH_NAV_OFERTAS}    10s
    Click Element    ${XPATH_NAV_OFERTAS}
    Wait Until Page Contains    Ofertas   15s

Ejecutar Busqueda Supermercado
    [Arguments]    ${camino}    ${producto}
    [Documentation]    Gestiona las búsquedas en las dos verticales de supermercado.
    ${url_destino}=    Set Variable If    '${camino}' == 'carrefour'    ${URL_CARREFOUR_LANDING}    ${URL_FULL_LANDING}
    Go To    ${url_destino}
    Wait Until Element Is Visible    ${INPUT_BUSCADOR}    15s
    Input Text       ${INPUT_BUSCADOR}    ${producto}
    Press Keys       ${INPUT_BUSCADOR}    ENTER


# ====================================================================
# --- 3. LOGICA EJERCICIO 2 (Tests 6 y 7) ---
# ====================================================================

Cuantificador de categoria
    [Arguments]    ${categoria_nombre}
    [Documentation]    Lógica del Test 6: Navega y prepara la extracción de totales.
    Navegar Hacia Categoria Inteligente    ${categoria_nombre}
    ${url_especifica}=    Set Variable If    '${categoria_nombre}' == 'Construcción'    https://listado.mercadolibre.com.ar/construccion/banos-sanitarios/nuevo/
    Cuantificar Resultados Subcategoria    ${url_especifica}    ${categoria_nombre}

Cuantificar Resultados Subcategoria
    [Arguments]    ${url_subcategoria}    ${nombre_subcategoria}
    [Documentation]    Motor de extracción: Obtiene el texto de cantidad y lo limpia para el reporte.
    Go To    ${url_subcategoria}
    Eliminar Cookies Si Existen
    Wait Until Element Is Visible    ${TXT_CANTIDAD_RESULTADOS}    20s
    ${valor_extraido}=    Get Text    ${TXT_CANTIDAD_RESULTADOS}
    ${numero_limpio}=    Replace String    ${valor_extraido}    resultados    ${EMPTY}
    ${numero_limpio}=    Strip String      ${numero_limpio}
    Log To Console    \n[RESULTADO] ${nombre_subcategoria}: ${numero_limpio}
    RETURN    ${numero_limpio}

Parametrizador de precio para categoria
    [Arguments]    ${min_precio}    ${max_precio}
    [Documentation]    Lógica del Test 7: Filtro por URL y reutilización del motor del Test 6.
    
    # 1. Validación Visual (Scroll suave)
    Go To    https://listado.mercadolibre.com.ar/construccion/banos-sanitarios/nuevo/
    Eliminar Cookies Si Existen
    Wait Until Page Contains    Precio    20s
    Execute JavaScript    document.evaluate("//*[contains(text(),'Precio')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView({behavior: 'smooth', block: 'center'});
    Sleep    2s    # Pausa para auditoría visual
    
    # 2. Aplicación de Filtro Robusto (URL)
    ${url_final}=    Set Variable    https://listado.mercadolibre.com.ar/construccion/banos-sanitarios/nuevo/_PriceRange_${min_precio}ARS-${max_precio}ARS_NoIndex_True
    Go To    ${url_final}
    
    # 3. REAPROVECHAMIENTO: Usamos la lógica de extracción ya definida
    Wait Until Element Is Visible    ${TXT_CANTIDAD_RESULTADOS}    15s
    ${total_filtrado}=    Get Text    ${TXT_CANTIDAD_RESULTADOS}
    ${solo_numero}=    Remove String    ${total_filtrado}    resultados
    
    Log To Console    \n[RESULTADO FINAL] Rango $${min_precio}-$${max_precio} -> Cantidad: ${solo_numero}