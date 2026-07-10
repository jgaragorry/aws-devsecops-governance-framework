#!/bin/bash
PREFIJO="garagorry-sre"
BUCKET_NAME="${PREFIJO}-tfstate"
TABLE_NAME="${PREFIJO}-tflocks"
echo "=== [FinOps / Auditoría] Verificando Recursos ==="
echo "📊 Estados de Terraform almacenados en S3:"
aws s3 ls "s3://$BUCKET_NAME" --recursive || echo "Bucket vacío o inexistente."
echo -e "\n🔒 Bloqueos (Locks) activos en DynamoDB:"
aws dynamodb scan --table-name "$TABLE_NAME" --query "Items" --output table 2>/dev/null || echo "Tabla inexistente."
