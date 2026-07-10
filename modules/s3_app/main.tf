variable "environment" {
  type = string
}

variable "vulnerable_mode" {
  type    = bool
  default = false # Mantener el default seguro para el análisis estático plano
}

# Colocamos las excepciones de auditoría para logging y versionamiento aquí
# tfsec:ignore:aws-s3-enable-bucket-logging
# tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "app_bucket" {
  bucket = "sre-linux-mastery-app-bucket-${var.environment}"
}

# Si vulnerable_mode = false, activa el bloqueo público
resource "aws_s3_bucket_public_access_block" "security_block" {
  count                   = var.vulnerable_mode ? 0 : 1
  bucket                  = aws_s3_bucket.app_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CORREGIDO: El ignore va justo encima de la declaración del recurso
# tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "crypto" {
  count  = var.vulnerable_mode ? 0 : 1
  bucket = aws_s3_bucket.app_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
