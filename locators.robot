*** Variables ***    # Variables globales y localizadores centralizados

${XPATH_USERNAME}    //*[@id="user-name"]    # Locators heredados (no usados aquí); mantienen compatibilidad si se reutiliza plantilla
${XPATH_PASSWORD}    //*[@id="password"]     # Ídem
${XPATH_LOGIN_BTN}    //*[@id="login-button"]    # Ídem
${XPATH_HOME_SCREEN}    //*[@id="root"]/div/div[1]    # Ídem
${XPATH_HEADER}    //*[@id="header_container"]/div[2]/span    # Ídem
${XPATH_ERROR}    //*[@data-test="error"]    # Ídem

${URL}    https://app.waynimovil.ar/prestamos    # URL base del flujo a automatizar
&{BROWSERS}    CH=chrome    FX=firefox    SF=safari    ED=edge    # Mapeo código corto -> navegador para ejecución declarativa

# Tabs / panel
${X_TAB_SIMULAR}          //*[@id="headlessui-tabs-tab-:Rmlbm:"]    # Tab "Simular" por ID que actualmente funciona en la UI
${X_PANEL_INDICADOR}      //div[contains(@class,'space-y-3')]//div[1]//input[1]    # Primer input visible como indicador de panel cargado

# Inputs formulario
${X_INPUT_DNI}            //div[contains(@class,'space-y-3')]//div[1]//input[1]    # Input de DNI (dentro del formulario)
${X_INPUT_CEL}            //*[@id="headlessui-tabs-panel-:Rqlbm:"]/div/form/div[1]/div[2]/input    # Input de celular
${X_INPUT_EMAIL}          //*[@id="headlessui-tabs-panel-:Rqlbm:"]/div/form/div[1]/div[5]/input    # Input de email
${X_CHECK_TYC}            //*[@id="headlessui-tabs-panel-:Rqlbm:"]/div/form/div[2]/label/input    # Checkbox TyC en el formulario
${X_BTN_CONTINUAR}        //*[@id="headlessui-tabs-panel-:Rqlbm:"]/div/form/button    # Botón Continuar del formulario principal
${X_INPUT_BIRTHDAY}       //*[@id="headlessui-tabs-panel-:Rqlbm:"]/div/form/div[1]/div[4]/input    # Input de fecha de nacimiento

# Botón "Continuar" del modal (tu XPath original largo)
${X_BTN_CONTINUAR_FINAL}    //button[contains(@class,'flex items-center transition duration-200 justify-center text-center rounded-full max-w-lg focus:outline-none focus-visible:ring-4 active:bg-green-900 hover:bg-green-800 hover:text-white hover:border-none bg-purple-900 hover:bg-primary-900 focus:ring-primary-500 focus-visible:ring-[#382D71]/25 border-transparent text-white font-bold text-base py-2 px-3 h-12 tracking-wide w-full')]//div[contains(@class,'flex-grow')][normalize-space()='Continuar']    # Botón Continuar dentro del modal

# Combobox bancos
${X_BTN_BANCOS}           //button[contains(@id,'headlessui-combobox-button')] | //*[@id="headlessui-tabs-panel-:Rqlbm:"]//button[@role='combobox'] | //*[name()='path' and contains(@d,'M14.1669 5')]/ancestor::button    # Botón para abrir el combo de bancos (varias alternativas)
${X_COMBO_INPUT}          //input[contains(@id,'headlessui-combobox-input')]    # Input de búsqueda dentro del combo (si aparece)
${X_COMBO_LIST}           //*[contains(@id,'headlessui-combobox-options')]    # Lista de opciones del combo

${X_OPTION_BY_TEXT_TMPL}      //*[(@role='option' or self::li) and .//p[normalize-space()="{{TEXT}}"]]    # Template de opción por texto exacto
${X_OPTION_BY_TEXT_CI_TMPL}   //*[(self::li or @role='option') and contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÜÑ','abcdefghijklmnopqrstuvwxyzáéíóúüñ'), "{{TEXT_LC}}")]    # Template de opción case-insensitive con soporte a acentos

&{BANK_TEXTS}    galicia=galicia    santander=santander    bbva=bbva    # Diccionario de bancos: clave -> texto visible en la UI

# Rutas/elementos de detección de outcome
${URL_NO_OFFER_PATH}          /prestamos/error/sin-oferta    # Fragmento de URL para identificar "sin oferta"
${URL_OK_CONTAINS}            google.com    # Fragmento de URL para identificar outcome OK (placeholder)
${X_NO_OFFER_H1}              //h1[contains(normalize-space(.),'no tenemos una oferta')]    # H1 de la pantalla de "sin oferta"
${X_NO_OFFER_BTN_CONTINUAR}   //button[contains(normalize-space(.),'Continuar al sitio web')]    # Botón de continuar en "sin oferta"

# Modal TyC (scope para Firefox)
${X_TYC_DIALOG}         //div[@role='dialog' or contains(@id,'headlessui-dialog') or contains(@class,'Dialog')]    # Contenedor del modal (varias señales)

# “He leído/acepto” dentro del modal (original + scopeado al modal)
${X_TYC_ACK_1}          //span[contains(@class,'font-medium')]//div[contains(@class,'border-gray-500')]    # Opción 1: sin scoping al modal
${X_TYC_ACK_2}          ${X_TYC_DIALOG}//span[contains(@class,'font-medium')]//div[contains(@class,'border-gray-500')] | ${X_TYC_DIALOG}//label[.//span or contains(normalize-space(.),'He leído') or contains(normalize-space(.),'Acepto')]//div[contains(@class,'border')]    # Opción 2: scopeada al modal + variantes

# ===== Autogestión (nuevos locators) =====
${URL_AUTOGESTION}    https://autogestion.waynimovil.ar/    # URL de la landing de Autogestión

# Nota: Selenium no interactúa con nodos de texto (…/text()), por eso apuntamos al elemento <p> y podemos leer su texto con Get Text si es necesario
${X_AUTOG_READY_TEXT}        //*[@id="__next"]/div/div/div/p[2]    # Párrafo 2 visible como indicador de pantalla cargada
${X_AUTOG_DNI_INPUT}         //*[@id="__next"]/div/div/div/form/div/input    # Campo de documento/DNI
${X_AUTOG_BTN_CONTINUAR}     //*[@id="__next"]/div/div/div/form/button    # Botón Continuar (requiere hover previo)
${X_AUTOG_LABEL_AFTER}       //*[@id="__next"]/div/div/div/form/div/div/label    # Label visible esperado tras hacer click en Continuar