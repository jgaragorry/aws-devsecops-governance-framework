#!/bin/bash
# -----------------------------------------------------------------------------
# SRE / FinOps - Análisis Estático de Costos con Infracost
# -----------------------------------------------------------------------------

echo "====================================================================="
echo "💰 INICIANDO ESTIMACIÓN DE COSTOS FINOPS CON INFRACOST"
echo "====================================================================="

# Validar que infracost esté instalado
if ! command -v infracost &> /dev/null; then
    echo "❌ Error: Infracost no está instalado. Ejecuta el script de instalación primero."
    exit 1
fi

# Rutas de los entornos del laboratorio 4
DEV_PATH="$HOME/sre-linux-mastery/Fase2/iac-mastery_4/environments/dev/ssm-param"
PROD_PATH="$HOME/sre-linux-mastery/Fase2/iac-mastery_4/environments/prod/ssm-param"

echo "📊 [Entorno: DEV] Analizando parámetros estáticos..."
if [ -d "$DEV_PATH" ]; then
    # Usamos --path apuntando al directorio de Terragrunt
    infracost breakdown --path "$DEV_PATH" --usage-file "$DEV_PATH/infracost-usage.yml" 2>/dev/null || \
    infracost breakdown --path "$DEV_PATH"
fi

echo -e "\n📊 [Entorno: PROD] Analizando parámetros estáticos..."
if [ -d "$PROD_PATH" ]; then
    infracost breakdown --path "$PROD_PATH"
fi

echo "====================================================================="
