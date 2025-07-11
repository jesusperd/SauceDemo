*** Settings ***
Library    SeleniumLibrary    
Library    Collections
Library    RequestsLibrary
Variables    variables.py

*** Variables ***
@{ADDED_PRODUCTS}    # Lista para productos agregados
@{REMOVE_BUTTONS}    # XPaths de botones para remover productos del carrito
...    //*[@id="remove-test.allthethings()-t-shirt-(red)"]
...    //*[@id="remove-sauce-labs-onesie"]
...    //*[@id="remove-sauce-labs-fleece-jacket"]
...    //*[@id="remove-sauce-labs-bolt-t-shirt"]
...    //*[@id="remove-sauce-labs-bike-light"]
...    //*[@id="remove-sauce-labs-backpack"]

*** Keywords ***
Open Sauce Demo In
    [Arguments]    ${browser_code}
    ${browser}=    Get From Dictionary    ${BROWSERS}    ${browser_code}
    Run Keyword If    '${browser}' == None    Fail    Navegador desconocido: ${browser_code}
    Run Keyword If    '${browser}' == 'chrome'    Disable security mode
    ...    ELSE
    ...    Open Browser    ${URL}    ${browser}
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=${XPATH_USERNAME}    timeout=10s

Disable security mode
    # Configura Chrome en modo incógnito y desactiva servicios de guardado de contraseñas
    ${chrome prefs}=    Evaluate    {'credentials_enable_service': False, 'profile.password_manager_enabled': False, 'profile.password_manager_leak_detection_enabled': False}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --incognito
    Call Method    ${options}    add_experimental_option    prefs    ${chrome prefs}
    Create Webdriver    Chrome    options=${options}
    Go To    ${URL}

Input Credentials And Login
    [Arguments]    ${user}
    Input Text    xpath=${XPATH_USERNAME}    ${user}
    Input Text    xpath=${XPATH_PASSWORD}    ${PASSWORD}
    Click Button    xpath=${XPATH_LOGIN_BTN}
    Wait Until Keyword Succeeds    10 times    1s    Run Keyword And Ignore Error    Element Should Be Visible    xpath=${XPATH_HEADER}
    ${error_visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath=${XPATH_ERROR}
    Run Keyword If    ${error_visible}    Fail    Login falló para usuario ${user} - mensaje de error visible

Add Product To Cart By Name
    [Arguments]    ${product_name}
    ${xpath}=    Get From Dictionary    ${PRODUCTS}    ${product_name}
    Click Button    xpath=${xpath}
    Append To List    ${ADDED_PRODUCTS}    ${product_name}

Add Products To Cart
    [Arguments]    @{product_names}
    Set Test Variable    @{ADDED_PRODUCTS}    []
    FOR    ${product}    IN    @{product_names}
        Add Product To Cart By Name    ${product}
    END

Go To Cart
    Click Element    xpath=//a[@data-test='shopping-cart-link']

Verify And Remove All Cart Items
    Click Element    xpath=//a[@data-test='shopping-cart-link']
    ${any_visible}=    Set Variable    True
    WHILE    ${any_visible}
        ${any_visible}=    Set Variable    False
        FOR    ${btn_xpath}    IN    @{REMOVE_BUTTONS}
            ${visible}=    Run Keyword And Return Status    Element Should Be Visible    xpath=${btn_xpath}    timeout=1s
            IF    ${visible}
                Click Button    xpath=${btn_xpath}
                ${any_visible}=    Set Variable    True
                Sleep    0.5s
            END
        END
    END
    Click Button    xpath=//*[@id="continue-shopping"]

Verify Departments In MercadoLibre
    # Consulta la API de MercadoLibre y valida que existan departamentos
    &{headers}=    Create Dictionary    User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36
    Create Session    ml    https://www.mercadolibre.com.ar    headers=${headers}
    ${response}=    GET On Session    ml    /menu/departments
    Should Be Equal As Integers    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    departments
    ${departments}=    Get From Dictionary    ${json}    departments
    Should Be True    ${departments} != []
    FOR    ${dep}    IN    @{departments}
        Dictionary Should Contain Key    ${dep}    name
    END

Capture Screenshot At End
    Capture Page Screenshot

Return To Home And Logout
    Wait Until Element Is Visible    xpath=${XPATH_HOME_SCREEN}    timeout=5s
    Click Button    xpath=//*[@id="react-burger-menu-btn"]
    Log    Menú lateral abierto, esperando que el botón de logout sea visible...
    Sleep    1s
    Wait Until Element Is Visible    xpath=//*[@id="logout_sidebar_link"]    timeout=10s
    Wait Until Element Is Enabled    xpath=//*[@id="logout_sidebar_link"]    timeout=5s
    Log    Haciendo click en logout (JS)...
    Click Element With JS    //*[@id="logout_sidebar_link"]
    Wait Until Element Is Visible    xpath=${XPATH_LOGIN_BTN}    timeout=5s
    Wait Until Element Is Visible    xpath=${XPATH_USERNAME}    timeout=5s

Click Element With JS
    [Arguments]    ${locator}
    Execute JavaScript    document.evaluate('${locator}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();

Wait And Click Continue Shopping
    [Documentation]    Espera, scrollea y hace click en el botón Continue Shopping.
    Wait Until Element Is Visible    xpath=//*[@id="continue-shopping"]    timeout=10s
    Scroll Element Into View    xpath=//*[@id="continue-shopping"]
    Wait Until Element Is Enabled    xpath=//*[@id="continue-shopping"]    timeout=5s
    Click Button    xpath=//*[@id="continue-shopping"]