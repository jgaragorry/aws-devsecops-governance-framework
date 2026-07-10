#!/bin/bash
set -e

PREFIJO="garagorry-sre"
BUCKET_NAME="${PREFIJO}-tfstate"
TABLE_NAME="${PREFIJO}-tflocks"

echo "=== [SRE / FinOps] Iniciando Purga Absoluta del Backend ==="

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "⏳ Extrayendo y eliminando todas las versiones y marcadores de S3..."

    # 1. Compilar y eliminar TODAS las versiones e históricos
    VERSIONS=$(aws s3api list-object-versions --bucket "$BUCKET_NAME" --output json || echo "{}")
    
    # Validar si el bucket tiene metadatos de versiones
    if [ "$VERSIONS" != "" ] && [ "$VERSIONS" != "null" ] && [ "$VERSIONS" != "{}" ]; then
        
        # El operador ? evita el error si Versions o DeleteMarkers son null
        OBJECTS=$(echo "$VERSIONS" | jq -c '{Objects: [.Versions[]?, .DeleteMarkers[]? | select(. != null) | {Key: .Key, VersionId: .VersionId}]}')
        
        # Si el JSON resultante contiene objetos, se ejecuta la purga en un solo paso masivo
        if [ "$OBJECTS" != "{\"Objects\":[]}" ] && [ "$OBJECTS" != "{\"Objects\":null}" ]; then
            echo "🔥 Eliminando objetos permanentemente de AWS S3..."
            aws s3api delete-objects --bucket "$BUCKET_NAME" --delete "$OBJECTS" > /dev/null
        fi
    fi

    echo "⏳ Eliminando contenedor físico del bucket..."
    aws s3api delete-bucket --bucket "$BUCKET_NAME"
    echo "✔ Bucket S3 eliminado con éxito."
fi

if aws dynamodb describe-table --table-name "$TABLE_NAME" 2>/dev/null; then
    echo "⏳ Eliminando tabla DynamoDB..."
    aws dynamodb delete-table --table-name "$TABLE_NAME" > /dev/null
    echo "✔ Tabla DynamoDB eliminada con éxito."
fi
