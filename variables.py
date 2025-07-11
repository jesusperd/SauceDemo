URL = "https://www.saucedemo.com/"    # URL base
PASSWORD = "secret_sauce"             # Contraseña por defecto

XPATH_USERNAME = '//*[@id="user-name"]'    # Input usuario
XPATH_PASSWORD = '//*[@id="password"]'     # Input contraseña
XPATH_LOGIN_BTN = '//*[@id="login-button"]'    # Botón login
XPATH_HOME_SCREEN = '//*[@id="root"]/div/div[1]'    # Elemento para validar home
XPATH_HEADER = '//*[@id="header_container"]/div[2]/span'    # Header
XPATH_ERROR = '//*[@data-test="error"]'    # Mensaje de error login

BROWSERS = {
    "CH": "chrome",
    "FX": "firefox",
    "SF": "safari",
    "ED": "edge"
}

USERS = [
    "standard_user",
    "locked_out_user",
    "problem_user",
    "performance_glitch_user",
    "error_user",
    "visual_user"
]

PRODUCTS = {
    "Sauce Labs Backpack": "//button[@data-test='add-to-cart-sauce-labs-backpack']",
    "Sauce Labs Bike Light": "//button[@data-test='add-to-cart-sauce-labs-bike-light']",
    "Sauce Labs Bolt T-Shirt": "//button[@data-test='add-to-cart-sauce-labs-bolt-t-shirt']",
    "Sauce Labs Fleece Jacket": "//button[@data-test='add-to-cart-sauce-labs-fleece-jacket']",
    "Sauce Labs Onesie": "//button[@data-test='add-to-cart-sauce-labs-onesie']",
    "Test.allTheThings() T-Shirt (Red)": "//button[@data-test='add-to-cart-test.allthethings()-t-shirt-(red)']"
}

XPATH_CONTINUE_SHOPPING_BTN = '//*[@id="continue-shopping"]'    # Botón para volver al home

