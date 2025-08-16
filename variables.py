URL = "https://app.waynimovil.ar/prestamos"    # URL base del flujo a automatizar (Wayni préstamos)
PASSWORD = "secret_sauce"             # Ejemplo heredado; no se usa en este flujo pero queda para futuras extensiones


BROWSERS = {    # Mapeo código corto -> nombre de driver; habilita ejecución declarativa por navegador
    "CH": "chrome",    # Chrome (con opciones específicas en keywords)
    "FX": "firefox",   # Firefox (con preferencias para reducir ruido)
    "SF": "safari",    # Safari (fallback por Open Browser)
    "ED": "edge"       # Edge (fallback por Open Browser)
}