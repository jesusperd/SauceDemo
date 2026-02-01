from webdriver_manager.chrome import ChromeDriverManager

def get_chromedriver_path():
    # Retorna la ruta del driver actualizado automáticamente
    return ChromeDriverManager().install()