#!/bin/bash
set -e
source ./backend-config.env

echo "=== [AWS S3] Estados de Terraform Almacenados Nativamente ==="
if aws s3api head-bucket --bucket "$TG_AWS_BUCKET" 2>/dev/null; then
    aws s3 ls "s3://$TG_AWS_BUCKET/" --recursive
else
    echo "⚠️ El Bucket S3 no existe o ya fue eliminado."
fi
