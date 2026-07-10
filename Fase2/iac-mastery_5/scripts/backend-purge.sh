#!/bin/bash
set -e
source ./backend-config.env

echo "⚠️ ADVERTENCIA CRÍTICA: Se eliminará permanentemente el almacenamiento de estados."
read -p "¿Deseas purgar los backends remotos de AWS y Azure? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "Operación cancelada."
    exit 0
fi

echo "=== [AWS S3] Purgando Versiones de Objetos Nativos ==="
versions=$(aws s3api list-object-versions --bucket "$TG_AWS_BUCKET" --output json 2>/dev/null || true)

if [ ! -z "$versions" ] && [ "$versions" != "null" ]; then
    aws s3api list-object-versions --bucket "$TG_AWS_BUCKET" | jq -r '.Versions[]? | "\(.Key) \(.VersionId)"' | while read -r key versionId; do
        aws s3api delete-object --bucket "$TG_AWS_BUCKET" --key "$key" --version-id "$versionId" >/dev/null
    done
    aws s3api list-object-versions --bucket "$TG_AWS_BUCKET" | jq -r '.DeleteMarkers[]? | "\(.Key) \(.VersionId)"' | while read -r key versionId; do
        aws s3api delete-object --bucket "$TG_AWS_BUCKET" --key "$key" --version-id "$versionId" >/dev/null
    done
fi

echo "=== [AWS S3] Eliminando Bucket Centralizado ==="
aws s3api delete-bucket --bucket "$TG_AWS_BUCKET" || echo "Bucket ya eliminado."

echo "=== [AZURE] Eliminando Grupo de Recursos del Backend ==="
az group delete --name "$TG_AZURE_RG" --yes --no-wait || echo "Grupo Azure ya eliminado o no requerido."

rm -f backend-config.env
echo "✅ [SRE] Ecosistema purgado e idempotente. Proyecto limpio."
