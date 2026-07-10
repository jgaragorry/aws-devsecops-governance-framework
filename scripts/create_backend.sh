#!/bin/bash
set -e
REGION="us-east-1"
BUCKET="sre-linux-mastery-tfstate-2026"

echo "=== [Idempotente] Verificando / Creando Bucket S3 para TFState ==="
if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
    echo "El bucket $BUCKET ya existe."
else
    echo "Creando bucket $BUCKET..."
    aws s3api create-bucket --bucket "$BUCKET" --region "$REGION"
    
    # Habilitar Versionado (Obligatorio para resguardar estados anteriores)
    aws s3api put-bucket-versioning --bucket "$BUCKET" --versioning-configuration Status=Enabled
    
    # Habilitar Cifrado por defecto
    aws s3api put-bucket-encryption --bucket "$BUCKET" --server-side-encryption-configuration '{
        "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
    echo "Bucket creado y protegido exitosamente."
fi
