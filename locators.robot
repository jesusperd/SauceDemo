*** Variables ***
${URL}              https://www.saucedemo.com/         # URL base de la web
${USERNAME}         standard_user                      # Usuario por defecto
${PASSWORD}         secret_sauce                       # Contraseña por defecto

${XPATH_USERNAME}   //*[@id="user-name"]               # Input usuario
${XPATH_PASSWORD}   //*[@id="password"]                # Input contraseña
${XPATH_LOGIN_BTN}  //*[@id="login-button"]            # Botón login
${XPATH_HOME_SCREEN}  //*[@id="root"]/div/div[1]       # Elemento para validar home
${XPATH_HEADER}     //*[@id="header_container"]/div[2]/span   # Header
${XPATH_ERROR}      //*[@data-test="error"]            # Mensaje de error login

${BROWSERS}    {"CH": "chrome", "FX": "firefox"}       # Diccionario de navegadores