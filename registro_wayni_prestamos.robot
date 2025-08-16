*** Settings ***    # Sección de configuración de la suite
Resource    keywords.robot    # Importa las palabras clave definidas en keywords.robot
Suite Teardown    Close All Browsers    # Cierra todos los navegadores al finalizar la suite

*** Test Cases ***    # Sección que define los casos de prueba
Registro En Chrome con Usuario No Disponible para Credito    # Caso: ejecuta el flujo en Chrome con datos que deberían llevar a "sin oferta"
    Open waynimovil in    CH        # Selecciona tu explorador de preferencia CH(Chrome) o FX(Firefox)
    Imput doc            19080841   # Ingrese documento de preferencia para el test
    Imput cel            1128895950     # Ingrese celular de preferencia para el test
    Imput bank           galicia    # Ingrese banco de preferencia para el test
    Imput birthday       24-12-1995    # Ingrese fecha de nacimiento de preferencia para el test
    Imput email          qa.tester@example.com    # Ingrese email de preferencia para el test
    Accept TyC And Continue    # Acepta TyC (formulario + modal) y continua el flujo
    Detect Last page            # Detecta el resultado final por URL y valida la pantalla correspondiente

#Código escalable y reutilizable orientado a reuso y parametrización: 
# permite combinar distintos logins (emails, DNI, fechas y bancos) y dejar casos predefinidos; 
# además, facilita mantener tests de regresión con datos fijos a propósito y, en pocos minutos, 
# crear tests individuales con características específicas para pruebas puntuales.
