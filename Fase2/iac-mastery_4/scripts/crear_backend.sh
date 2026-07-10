#!/bin/bash
set -e
PREFIJO="garagorry-sre"
BUCKET_NAME="${PREFIJO}-tfstate"
TABLE_NAME="${PREFIJO}-tflocks"
REGION="us-east-1"
echo "=== [DevSecOps] Creando Backend Remoto Seguro ==="
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "✔ El bucket S3 $BUCKET_NAME ya existe."
else
    echo "⏳ Creando bucket S3..."
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION"
    aws s3api put-bucket-encryption --bucket "$BUCKET_NAME" --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
    aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled
    echo "✔ Bucket S3 listo con cifrado y versionado activo."
fi
if aws dynamodb describe-table --table-name "$TABLE_NAME" 2>/dev/null; then
    echo "✔ La tabla DynamoDB $TABLE_NAME ya existe."
else
    echo "⏳ Creando tabla DynamoDB..."
    aws dynamodb create-table --table-name "$TABLE_NAME" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region "$REGION"
    echo "✔ Tabla DynamoDB lista (Modo On-Demand - FinOps)."
fi
