#!/bin/bash
set -e
BUCKET="sre-linux-mastery-tfstate-2026"

echo "=== [Idempotente] Vaciando versiones del Bucket S3 de forma exhaustiva ==="
if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
    
    echo "1. Removiendo todas las versiones de objetos vivos..."
    aws s3api list-object-versions --bucket "$BUCKET" --output json --query 'Versions[].{Key:Key,VersionId:VersionId}' | jq '{Objects: .}' > /tmp/v_objects.json
    if jq '.Objects != null and (.Objects | length > 0)' /tmp/v_objects.json | grep -q "true"; then
        aws s3api delete-objects --bucket "$BUCKET" --delete file:///tmp/v_objects.json
    fi

    echo "2. Removiendo todos los Marcadores de Eliminación (Delete Markers)..."
    aws s3api list-object-versions --bucket "$BUCKET" --output json --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' | jq '{Objects: .}' > /tmp/d_objects.json
    if jq '.Objects != null and (.Objects | length > 0)' /tmp/d_objects.json | grep -q "true"; then
        aws s3api delete-objects --bucket "$BUCKET" --delete file:///tmp/d_objects.json
    fi

    echo "3. Eliminando el Bucket S3 desde la raíz..."
    aws s3 rb "s3://$BUCKET" --force
    echo "✅ Backend destruido por completo de AWS."
else
    echo "✅ El backend remoto ya no existe o ya fue eliminado."
fi

# Limpieza de archivos temporales locales
rm -f /tmp/v_objects.json /tmp/d_objects.json
