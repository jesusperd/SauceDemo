*** Settings ***    # Configuración de la suite de Autogestión
Resource    keywords.robot    # Reusa las keywords del proyecto
Suite Teardown    Close All Browsers    # Cierra navegadores al finalizar

*** Test Cases ***    # Casos de prueba
Autogestion - Ingreso de DNI Sin Credito( con problemas ) y verificación de pantalla    # Caso simple sobre la landing de Autogestión
    Open autogestion in    CH    # Abre https://autogestion.waynimovil.ar/ en el navegador indicado (CH/FX)
    Autogestion wait landing ready    # Espera la carga de la pantalla verificando el párrafo 2 visible
    Autogestion imput doc    19080841    # Tipea el documento en el campo de la landing
    Autogestion click continuar    # Hace hover y click en el botón Continuar
    Autogestion should show label after continue    # Valida que el label esperado quede visible tras continuar