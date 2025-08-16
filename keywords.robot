*** Settings ***    # Configuración de recursos y librerías
Library    SeleniumLibrary    # Librería Selenium para automatización web
Library    Collections        # Librería para manejar listas y diccionarios
Library    String             # Librería para utilidades de strings
Resource   locators.robot     # Importa variables y localizadores centralizados

*** Keywords ***    # Palabras clave reutilizables de la suite

Open waynimovil in    # Abre el sitio en el navegador indicado y prepara la ventana
    [Arguments]    ${browser_code}    # Código del navegador a usar (CH, FX, SF, ED)
    ${browser}=    Get From Dictionary    ${BROWSERS}    ${browser_code}    # Resuelve el nombre real del navegador a partir del código

    IF    '${browser}' == 'chrome'    # Configuración específica para Chrome
        ${ch_opts}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys    # Crea opciones de Chrome
        Call Method    ${ch_opts}    add_argument    --disable-notifications    # Bloquea notificaciones nativas
        ${prefs}=    Create Dictionary    profile.default_content_setting_values.notifications=2    profile.default_content_settings.popups=0    # Preferencias del perfil de Chrome
        Call Method    ${ch_opts}    add_experimental_option    prefs    ${prefs}    # Aplica preferencias al perfil
        Create Webdriver    Chrome    options=${ch_opts}    # Crea el WebDriver de Chrome con opciones
        Go To    ${URL}    # Navega a la URL base

    ELSE IF    '${browser}' == 'firefox'    # Configuración específica para Firefox
        ${fx_opts}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys    # Crea opciones de Firefox
        Call Method    ${fx_opts}    add_argument    -private    # Abre en modo privado
        Call Method    ${fx_opts}    set_preference    browser.privatebrowsing.autostart    ${True}    # Fuerza private browsing
        Call Method    ${fx_opts}    set_preference    permissions.default.desktop-notification    2    # Bloquea notificaciones de escritorio
        Call Method    ${fx_opts}    set_preference    dom.webnotifications.enabled                 ${False}    # Bloquea notificaciones web
        Create Webdriver    Firefox    options=${fx_opts}    # Crea el WebDriver de Firefox con opciones
        Go To    ${URL}    # Navega a la URL base

    ELSE    # Fallback para Safari/Edge u otros navegadores
        Open Browser    ${URL}    ${browser}    # Abre navegador usando SeleniumLibrary sin opciones especiales
    END

    Maximize Browser Window    # Maximiza la ventana del navegador

    Wait Until Element Is Visible    xpath=${X_TAB_SIMULAR}    15s    # Espera hasta que el tab "Simular" sea visible
    Click Element    xpath=${X_TAB_SIMULAR}    # Clic en el tab "Simular" para mostrar el formulario

Dismiss consent/ad banner if present    # Cierra banners/consents si aparecen
    ${locators}=    Create List    # Crea lista de posibles locators de botones de consentimiento/cierre
    ...    //button[./*[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÜÑ','abcdefghijklmnopqrstuvwxyzáéíóúüñ'),'permitir')]]    # Botones con texto "permitir"
    ...    //button[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÜÑ','abcdefghijklmnopqrstuvwxyzáéíóúüñ'),'aceptar')]    # Botones "aceptar"
    ...    //button[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÜÑ','abcdefghijklmnopqrstuvwxyzáéíóúüñ'),'rechazar')]    # Botones "rechazar"
    ...    //button[contains(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÜÑ','abcdefghijklmnopqrstuvwxyzáéíóúüñ'),'no gracias')]    # Botones "no gracias"
    ...    //*[contains(@class,'close') or contains(@class,'dismiss')][self::button or self::a]    # Elementos por clase "close/dismiss"
    FOR    ${loc}    IN    @{locators}    # Itera por cada locator posible
        ${ok}=    Run Keyword And Return Status    Click Element    xpath=${loc}    # Intenta clickear y devuelve True/False sin fallar
        IF    ${ok}    # Si pudo clickear uno
            RETURN    # Sale del keyword para no sobreclicar
        END
    END    # Si no encontró nada, continúa sin error

Imput doc    # Completa el DNI en el formulario
    [Arguments]    ${dni}    # Documento a ingresar
    Wait Until Element Is Visible    xpath=${X_INPUT_DNI}    10s    # Espera visibilidad del input DNI
    Click Element    xpath=${X_INPUT_DNI}    # Foco en el input DNI
    Input Text       xpath=${X_INPUT_DNI}    ${dni}    # Ingresa el DNI

Imput cel    # Completa el celular en el formulario
    [Arguments]    ${cel}    # Número de celular
    Click Element    xpath=${X_INPUT_CEL}    # Foco en el input cel
    Input Text       xpath=${X_INPUT_CEL}    ${cel}    # Ingresa el celular

Imput bank    # Selecciona el banco desde el combobox
    [Arguments]    ${bank_key}    # Clave del banco (ej. galicia)
    ${search_text}=    Get From Dictionary    ${BANK_TEXTS}    ${bank_key}    # Resuelve la clave a texto del banco
    Click Element    xpath=${X_BTN_BANCOS}    # Abre el combobox de bancos
    ${has_input}=    Run Keyword And Return Status    Element Should Be Visible    xpath=${X_COMBO_INPUT}    1s    # Verifica si hay input de búsqueda dentro del combo
    IF    ${has_input}    # Si hay input
        Clear Element Text    xpath=${X_COMBO_INPUT}    # Limpia el input de búsqueda
        Input Text           xpath=${X_COMBO_INPUT}    ${search_text}    # Escribe el texto del banco para filtrar
        Wait Until Element Is Visible    xpath=${X_COMBO_LIST}    5s    # Espera que se muestre la lista de opciones filtrada
    END
    ${search_lc}=    Convert To Lowercase    ${search_text}    # Convierte el texto del banco a minúsculas para matching case-insensitive
    ${opt_xpath}=    Replace String    ${X_OPTION_BY_TEXT_CI_TMPL}    {{TEXT_LC}}    ${search_lc}    # Construye el XPath de opción con el texto buscado
    ${visible}=    Run Keyword And Return Status    Wait Until Keyword Succeeds    6x    600ms    Element Should Be Visible    xpath=${opt_xpath}    # Espera corta en retries para que aparezca la opción
    IF    ${visible}    # Si la opción está visible
        Click Element    xpath=${opt_xpath}    # Clic en la opción del banco
    ELSE    # Si no está visible
        IF    ${has_input}    # Si hay input de búsqueda
            Press Keys    xpath=${X_COMBO_INPUT}    ARROW_DOWN    # Baja a la primera opción
            Press Keys    xpath=${X_COMBO_INPUT}    ENTER         # Confirma selección
        ELSE    # Si no hay input (combo sin campo)
            Fail    No se encontró la opción de banco: ${search_text}    # Falla explícitamente con mensaje
        END
    END

Imput birthday    # Completa la fecha de nacimiento y dispara validación
    [Arguments]    ${dob_dd_mm_yyyy}    # Fecha en formato dd-mm-aaaa o dd/mm/aaaa
    ${dob_dd_mm_yyyy}=    Replace String    ${dob_dd_mm_yyyy}    -    /    # Normaliza guiones a barras
    Wait Until Element Is Visible    xpath=${X_INPUT_BIRTHDAY}    10s    # Espera visibilidad del input de fecha
    Click Element                    xpath=${X_INPUT_BIRTHDAY}    # Foco en el input fecha
    Press Keys                       xpath=${X_INPUT_BIRTHDAY}    CTRL+a    # Selecciona todo
    Press Keys                       xpath=${X_INPUT_BIRTHDAY}    BACKSPACE  # Borra contenido
    Input Text                       xpath=${X_INPUT_BIRTHDAY}    ${dob_dd_mm_yyyy}    # Ingresa la fecha
    Press Keys                       xpath=${X_INPUT_BIRTHDAY}    TAB    # Sale del campo para validar en blur
    Run Keyword And Ignore Error     Element Attribute Value Should Be    xpath=${X_INPUT_BIRTHDAY}    value    ${dob_dd_mm_yyyy}    # Verifica valor (no corta ejecución si la máscara cambia separadores)

Imput email    # Completa el email y dispara validación
    [Arguments]    ${email}    # Email a ingresar
    Wait Until Element Is Visible    xpath=${X_INPUT_EMAIL}    10s    # Espera visibilidad del input email
    Click Element                    xpath=${X_INPUT_EMAIL}    # Foco en el input email
    Press Keys                       xpath=${X_INPUT_EMAIL}    CTRL+a    # Selecciona todo
    Press Keys                       xpath=${X_INPUT_EMAIL}    BACKSPACE  # Borra contenido
    Input Text                       xpath=${X_INPUT_EMAIL}    ${email}   # Ingresa el email
    Press Keys                       xpath=${X_INPUT_EMAIL}    TAB        # Fuerza validación

Accept TyC And Continue    # Acepta TyC en el formulario, marca en el modal y presiona Continuar
    Dismiss consent/ad banner if present    # Cierra banners si hubiese, para evitar bloqueos de click
    Click Element    xpath=${X_CHECK_TYC}    # Marca el checkbox de TyC en el formulario principal
    Click Element    xpath=${X_BTN_CONTINUAR}    # Click en Continuar del formulario para abrir el modal de TyC
    Wait Until Page Contains Element    xpath=${X_TYC_DIALOG}    12s    # Espera a que el modal esté presente
    ${clicked}=    Run Keyword And Return Status    Click Element    xpath=${X_TYC_ACK_1}    # Primer intento para tildar "He leído/Acepto" dentro del modal
    IF    not ${clicked}    # Si el primer intento falla
        ${clicked}=    Run Keyword And Return Status    Click Element    xpath=${X_TYC_ACK_2}    # Segundo intento con locator alternativo scopeado al modal
    END
    IF    not ${clicked}    # Si aún no pudo clickear
        ${ack_el}=    Get Webelement    xpath=${X_TYC_ACK_2}    # Obtiene la referencia del elemento
        Execute JavaScript    arguments[0].click()    ${ack_el}    # Hace click vía JavaScript como último recurso (útil en Firefox)
    END
    Wait Until Element Is Visible    xpath=${X_BTN_CONTINUAR_FINAL}    8s    # Espera que aparezca el botón Continuar del modal
    Scroll Element Into View         xpath=${X_BTN_CONTINUAR_FINAL}    # Asegura que el botón esté en viewport
    Mouse Over                       xpath=${X_BTN_CONTINUAR_FINAL}    # Hover por si habilita estilos/estado
    Sleep    300ms    # Pequeño delay para permitir el cambio de estado del botón
    Wait Until Element Is Enabled    xpath=${X_BTN_CONTINUAR_FINAL}    6s    # Verifica que el botón esté habilitado
    Click Element                    xpath=${X_BTN_CONTINUAR_FINAL}    # Click en Continuar dentro del modal

Detect outcome    # Detecta el resultado final por cambios de URL
    [Arguments]    ${timeout_seconds}=25    # Tiempo máximo de espera
    FOR    ${i}    IN RANGE    ${timeout_seconds}    # Itera por segundos
        ${url}=    Get Location    # Obtiene la URL actual
        ${is_no}=  Run Keyword And Return Status    Should Contain    ${url}    ${URL_NO_OFFER_PATH}    # Verifica si la URL contiene "sin oferta"
        IF    ${is_no}    # Si está en "sin oferta"
            RETURN    NO_DISPONIBLE    # Devuelve estado NO_DISPONIBLE
        END
        ${is_ok}=  Run Keyword And Return Status    Should Contain    ${url}    ${URL_OK_CONTAINS}    # Verifica si la URL contiene patrón OK
        IF    ${is_ok}    # Si es OK
            RETURN    OK    # Devuelve estado OK
        END
        Sleep    1s    # Espera 1 segundo y reintenta
    END
    Fail    No se detectó resultado esperado dentro de ${timeout_seconds}s (URL actual: ${url})    # Falla si no hubo outcome

Screen credit not available    # Valida la pantalla de "sin oferta de crédito"
    Wait Until Location Contains    ${URL_NO_OFFER_PATH}    15s    # Espera que la URL contenga el path de sin oferta
    Wait Until Element Is Visible   xpath=${X_NO_OFFER_H1}              10s    # Valida que el H1 esté visible
    Wait Until Element Is Visible   xpath=${X_NO_OFFER_BTN_CONTINUAR}   10s    # Valida que el botón de continuar esté visible

Detect Last page    # Orquesta las validaciones finales según outcome
    [Arguments]    ${timeout_seconds}=25    # Tiempo máximo para detectar el outcome
    ${outcome}=    Detect outcome    ${timeout_seconds}    # Obtiene el outcome detectado
    IF    '${outcome}' == 'NO_DISPONIBLE'    # Si no hay oferta
        Screen credit not available    # Ejecuta validaciones de la pantalla "sin oferta"
    ELSE IF    '${outcome}' == 'OK'    # Si outcome es OK
        Log To Console    Resultado OK (redireccionó a Google)    # Log informativo en consola
    END





Open autogestion in    # Abre la URL de Autogestión en el navegador indicado con las mismas opciones que Wayni
    [Arguments]    ${browser_code}    # Código del navegador (CH/FX/SF/ED)
    ${browser}=    Get From Dictionary    ${BROWSERS}    ${browser_code}    # Traduce código a nombre real del driver
    IF    '${browser}' == 'chrome'    # Configuración Chrome
        ${ch_opts}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys    # Crea opciones de Chrome
        Call Method    ${ch_opts}    add_argument    --disable-notifications    # Desactiva notificaciones nativas
        ${prefs}=    Create Dictionary    profile.default_content_setting_values.notifications=2    profile.default_content_settings.popups=0    # Evita popups
        Call Method    ${ch_opts}    add_experimental_option    prefs    ${prefs}    # Aplica preferencias
        Create Webdriver    Chrome    options=${ch_opts}    # Crea WebDriver Chrome
        Go To    ${URL_AUTOGESTION}    # Navega a Autogestión
    ELSE IF    '${browser}' == 'firefox'    # Configuración Firefox
        ${fx_opts}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys    # Crea opciones de Firefox
        Call Method    ${fx_opts}    add_argument    -private    # Modo privado
        Call Method    ${fx_opts}    set_preference    browser.privatebrowsing.autostart    ${True}    # Fuerza private
        Call Method    ${fx_opts}    set_preference    permissions.default.desktop-notification    2    # Bloquea notificaciones
        Call Method    ${fx_opts}    set_preference    dom.webnotifications.enabled                 ${False}    # Bloquea web notifications
        Create Webdriver    Firefox    options=${fx_opts}    # Crea WebDriver Firefox
        Go To    ${URL_AUTOGESTION}    # Navega a Autogestión
    ELSE    # Otros navegadores
        Open Browser    ${URL_AUTOGESTION}    ${browser}    # Abre en navegador genérico
    END
    Maximize Browser Window    # Maximiza la ventana

Autogestion wait landing ready    # Espera que la landing cargue (párrafo 2 visible) y valida que tenga texto
    Wait Until Element Is Visible    xpath=${X_AUTOG_READY_TEXT}    15s    # Espera que el elemento <p>[2] esté visible
    ${txt}=    Get Text    xpath=${X_AUTOG_READY_TEXT}    # Lee el texto del párrafo
    Should Not Be Empty    ${txt}    # Asegura que el texto no esté vacío (indicador de carga correcta)

Autogestion imput doc    # Escribe el documento en el input de la landing
    [Arguments]    ${dni}    # Documento a ingresar
    Wait Until Element Is Visible    xpath=${X_AUTOG_DNI_INPUT}    10s    # Espera visibilidad del input
    Click Element                    xpath=${X_AUTOG_DNI_INPUT}    # Foco en el campo
    Press Keys                       xpath=${X_AUTOG_DNI_INPUT}    CTRL+a    # Selecciona todo
    Press Keys                       xpath=${X_AUTOG_DNI_INPUT}    BACKSPACE  # Limpia contenido
    Input Text                       xpath=${X_AUTOG_DNI_INPUT}    ${dni}    # Ingresa el DNI

Autogestion click continuar    # Hace hover sobre el botón y luego clickear (algunas UIs requieren hover para habilitar estilos/estado)
    Wait Until Element Is Visible    xpath=${X_AUTOG_BTN_CONTINUAR}    10s    # Espera que el botón esté visible
    Scroll Element Into View         xpath=${X_AUTOG_BTN_CONTINUAR}    # Asegura que esté en el viewport
    Mouse Over                       xpath=${X_AUTOG_BTN_CONTINUAR}    # Hover previo sobre el botón
    Sleep    300ms    # Pequeño delay para que apliquen estados visuales/habilitación
    Wait Until Element Is Enabled    xpath=${X_AUTOG_BTN_CONTINUAR}    6s    # Verifica que esté habilitado
    Click Element                    xpath=${X_AUTOG_BTN_CONTINUAR}    # Click en Continuar

Autogestion should show label after continue    # Valida que tras continuar aparezca el label esperado
    Wait Until Element Is Visible    xpath=${X_AUTOG_LABEL_AFTER}    10s    # Espera que el label sea visible
