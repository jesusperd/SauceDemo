import os

# --- ENDPOINTS ---
URL_ML = "https://www.mercadolibre.com.ar"
URL_CARREFOUR_LANDING = "https://www.mercadolibre.com.ar/supermercado/carrefour"
URL_FULL_LANDING = "https://www.mercadolibre.com.ar/supermercado/market"
URL_OFERTAS_DIA = "https://www.mercadolibre.com.ar/ofertas?promotion_type=deal_of_the_day"

# --- CONFIGURACIÓN DE RUTAS ---
# Detecta automáticamente la carpeta raíz para guardar resultados
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EVIDENCIAS_DIR = os.path.join(BASE_DIR, "results")