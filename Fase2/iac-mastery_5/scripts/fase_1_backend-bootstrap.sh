#!/bin/bash
# ==============================================================================
# SCRIPT: backend-bootstrap.sh
# PROPÓSITO: Creación aislada e idempotente del backend multi-nube.
# ==============================================================================
set -e

# Variables del Backend (Asegura un ID único para evitar colisiones globales en S3)
UNIQUE_ID="sre-lab-$(date +%s)"
AWS_REGION="us-east-1"
AWS_BUCKET_NAME="${UNIQUE_ID}-tfstate"

AZURE_RG="rg-bootstrap-tfstate"
AZURE_LOCATION="eastus"
AZURE_STORAGE_ACT="st${UNIQUE_ID//-/}"
AZURE_CONTAINER="tfstate"

echo "=== [AWS] Creando Bucket S3 para Estados ==="
aws s3api create-bucket --bucket "$AWS_BUCKET_NAME" --region "$AWS_REGION"

echo "=== [AWS] Habilitando Versionamiento Fuerte (SRE Best Practice) ==="
aws s3api put-bucket-versioning --bucket "$AWS_BUCKET_NAME" --versioning-configuration Status=Enabled

echo "=== [AWS] Bloqueando todo Acceso Público (SecOps) ==="
aws s3api put-public-access-block --bucket "$AWS_BUCKET_NAME" --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "=== [AZURE] Creando Grupo de Recursos para Estado ==="
az group create --name "$AZURE_RG" --location "$AZURE_LOCATION" --output table

echo "=== [AZURE] Creando Storage Account (FinOps: Capa LRS Económica) ==="
az storage account create --name "$AZURE_STORAGE_ACT" --resource-group "$AZURE_RG" --location "$AZURE_LOCATION" --sku Standard_LRS --allow-blob-public-access false --output table

echo "=== [AZURE] Habilitando Versionamiento en Blobs ==="
az storage account blob-service-properties update --account-name "$AZURE_STORAGE_ACT" --resource-group "$AZURE_RG" --enable-versioning true --output table

echo "=== [AZURE] Creando Contenedor de Estado ==="
az storage container create --name "$AZURE_CONTAINER" --account-name "$AZURE_STORAGE_ACT" --output table

# Inyección dinámica de variables de entorno para Terragrunt
cat <<EOF > backend-config.env
export TG_AWS_BUCKET="$AWS_BUCKET_NAME"
export TG_AZURE_RG="$AZURE_RG"
export TG_AZURE_STORAGE_ACT="$AZURE_STORAGE_ACT"
export TG_AZURE_CONTAINER="$AZURE_CONTAINER"
EOF

echo -e "\n======================================================="
echo "   BACKEND CONFIGURADO Y REGISTRADO EXITOSAMENTE"
echo "======================================================="
echo "Variables guardadas en: backend-config.env"
echo "AWS S3 Bucket: $AWS_BUCKET_NAME"
echo "Azure Storage Account: $AZURE_STORAGE_ACT"
echo "======================================================="
