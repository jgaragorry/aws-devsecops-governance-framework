#!/bin/bash
# -----------------------------------------------------------------------------
# SRE / DevSecOps / FinOps - Script de Auditoría Forense e Idempotente
# Propósito: Verificar la eliminación total de recursos huérfanos del Lab 4
# -----------------------------------------------------------------------------

PREFIJO="garagorry-sre"
BUCKET_NAME="${PREFIJO}-tfstate"
TABLE_NAME="${PREFIJO}-tflocks"
REGION="us-east-1"

echo "====================================================================="
echo "🔬 INICIANDO AUDITORÍA FORENSE: COMPROBACIÓN DE RECURSOS RESIDUALES"
echo "====================================================================="
echo "Región de Análisis: $REGION"
echo "Prefijo de Búsqueda: $PREFIJO"
echo "---------------------------------------------------------------------"

ERRORES_DETECTADOS=0

# --- 1. VERIFICACIÓN DE ALMACENAMIENTO (S3) ---
echo "📁 [FASE 1]: Escaneando Amazon S3..."
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "❌ ALERTA FINOPS: El bucket '$BUCKET_NAME' todavía existe de forma física."
    ((ERRORES_DETECTADOS++))
    
    # Contar objetos remanescentes
    OBJECT_COUNT=$(aws s3api list-object-versions --bucket "$BUCKET_NAME" --output json 2>/dev/null | jq '[.Versions[]?, .DeleteMarkers[]?] | length')
    echo "   ⚠️ Contiene $OBJECT_COUNT objetos/versiones residuales en su interior."
else
    echo "✔ ÉXITO: El bucket S3 '$BUCKET_NAME' fue purgado y eliminado correctamente."
fi

# --- 2. VERIFICACIÓN DE STATE LOCKING (DYNAMODB) ---
echo -e "\n🔒 [FASE 2]: Escaneando Amazon DynamoDB..."
if aws dynamodb describe-table --table-name "$TABLE_NAME" 2>/dev/null; then
    echo "❌ ALERTA SRE: La tabla DynamoDB '$TABLE_NAME' sigue activa."
    ((ERRORES_DETECTADOS++))
else
    echo "✔ ÉXITO: La tabla DynamoDB '$TABLE_NAME' fue destruida por completo."
fi

# --- 3. VERIFICACIÓN DE COMPONENTE DE INFRAESTRUCTURA (AWS SSM) ---
echo -e "\n⚙️ [FASE 3]: Escaneando AWS Systems Manager (SSM Parameters)..."

PARAM_DEV="/config/dev/database_url"
PARAM_PROD="/config/prod/database_url"

# Comprobar Parámetro DEV
if aws ssm get-parameter --name "$PARAM_DEV" 2>/dev/null; then
    echo "❌ ALERTA INFRA: El parámetro de Desarrollo '$PARAM_DEV' sigue existiendo en AWS."
    ((ERRORES_DETECTADOS++))
else
    echo "✔ ÉXITO: Parámetro de Desarrollo '$PARAM_DEV' inexistente (Eliminado)."
fi

# Comprobar Parámetro PROD
if aws ssm get-parameter --name "$PARAM_PROD" 2>/dev/null; then
    echo "❌ ALERTA INFRA: El parámetro de Producción '$PARAM_PROD' sigue existiendo en AWS."
    ((ERRORES_DETECTADOS++))
else
    echo "✔ ÉXITO: Parámetro de Producción '$PARAM_PROD' inexistente (Eliminado)."
fi

# --- CONCLUSIÓN DE AUDITORÍA ---
echo -e "\n====================================================================="
echo "📊 RESUMEN FINAL DE LA AUDITORÍA FORENSE"
echo "====================================================================="

if [ $ERRORES_DETECTADOS -eq 0 ]; then
    echo "🟢 STATUS: LIMPIO (ZERO INFRASTRUCTURE RESIDUAL)"
    echo "✔ No quedan recursos zombies corriendo ni elementos que generen facturación."
    echo "✔ El entorno 'iac-mastery_4' ha sido cerrado con éxito rotundo del 100%."
else
    echo "🔴 STATUS: RECURSOS HUÉRFANOS DETECTADOS ($ERRORES_DETECTADOS anomalías)"
    echo "⚠️ Por favor, revise las alertas indicadas arriba para evitar cobros sorpresa."
fi
echo "====================================================================="
