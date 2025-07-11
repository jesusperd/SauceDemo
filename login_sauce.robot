*** Settings ***
Resource     keywords.robot

*** Test Cases ***
# Ejemplo de test seteable:
# Puedes cambiar el navegador: FX (firefox), CH (chrome)
# Puedes cambiar el usuario: standard_user, locked_out_user, problem_user, performance_glitch_user, error_user, visual_user
# Puedes agregar 1 o más productos, separados por espacio. Opciones:
#   Sauce Labs Backpack
#   Sauce Labs Bike Light
#   Sauce Labs Bolt T-Shirt
#   Sauce Labs Fleece Jacket
#   Sauce Labs Onesie
#   Sauce Labs Test.allTheThings() T-Shirt (Red)
Login With Standard User And Two Products In Chrome
    [Teardown]    Capture Screenshot At End
    Open Sauce Demo In    CH    # Navegador: FX (firefox) o CH (chrome)
    Input Credentials And Login    standard_user    # Usuario: ver opciones arriba
    Add Products To Cart    Sauce Labs Backpack    # Puedes agregar más productos aquí, separados por espacio
    # Ejemplo: Add Products To Cart    Sauce Labs Backpack  Sauce Labs Bike Light
    Go To Cart 
    Verify And Remove All Cart Items
    Return To Home And Logout
    Close Browser

# Test: login, no agrega productos (test fallará a propósito si no descomentas productos)
Login With Standard User And One Product In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    #Sauce Labs Backpack  #Sauce Labs Bike Light
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: login y agrega tres productos
Login With Standard User And One Product In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    Sauce Labs Backpack  Sauce Labs Bike Light  Sauce Labs Bolt T-Shirt
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: login y agrega cuatro productos
Login With Standard User And One Product In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    Sauce Labs Backpack  Sauce Labs Bike Light  Sauce Labs Bolt T-Shirt  Sauce Labs Fleece Jacket
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: login y agrega cinco productos
Login With Standard User And One Product In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    Sauce Labs Backpack  Sauce Labs Bike Light  Sauce Labs Bolt T-Shirt  Sauce Labs Fleece Jacket  Sauce Labs Onesie
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: login y agrega seis productos
Login With Standard User And One Product In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    Sauce Labs Backpack  Sauce Labs Bike Light  Sauce Labs Bolt T-Shirt  Sauce Labs Fleece Jacket  Sauce Labs Onesie  Sauce Labs Test.allTheThings() T-Shirt (Red)
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: login con usuario bloqueado
Login With Locked Out User In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    Sauce Labs Backpack    
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: login con usuario problemático
Login With Problem User In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    Sauce Labs Backpack    
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: login con usuario performance glitch
Login With Performance Glitch User In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    Sauce Labs Backpack    
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: login con usuario error
Login With Error User In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    Sauce Labs Backpack    
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: login con usuario visual
Login With Visual User In Chrome
    [Teardown]    Capture Page Screenshot
    Open Sauce Demo In    CH
    Input Credentials And Login    standard_user
    Add Products To Cart    Sauce Labs Backpack    
    Go To Cart
    Verify And Remove All Cart Items
    Close Browser 

# Test: consulta API de MercadoLibre y valida departamentos
Verify MercadoLibre Departments
    [Teardown]    Capture Page Screenshot
    Verify Departments In MercadoLibre