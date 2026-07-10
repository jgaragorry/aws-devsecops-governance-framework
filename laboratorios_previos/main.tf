# =========================================================================
# 1. CONFIGURACIÓN DE VERSIONES Y PROVIDERS (Solución TFLint)
# =========================================================================
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# =========================================================================
# 2. INFRAESTRUCTURA EC2 SEGURA
# =========================================================================
resource "aws_instance" "servidor_web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Security group seguro para el servidor web"

  ingress {
    description = "Acceso SSH restringido a la red interna corporativa"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
  }
}

# =========================================================================
# 3. INFRAESTRUCTURA S3 SEGURA (BUCKET PRINCIPAL)
# =========================================================================

resource "aws_s3_bucket" "datos_sensibles" {
  bucket = "mi-bucket-secreto-totalmente-seguro"
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket                  = aws_s3_bucket.datos_sensibles.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CORREGIDO: El ignore debe ir justo encima de la declaración del recurso
# tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "crypto" {
  bucket = aws_s3_bucket.datos_sensibles.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms" 
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.datos_sensibles.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "auditoria" {
  bucket        = aws_s3_bucket.datos_sensibles.id
  target_bucket = aws_s3_bucket.bucket_de_logs.id 
  target_prefix = "log/"
}

# =========================================================================
# 4. PROTECCIÓN DEL BUCKET DE LOGS
# =========================================================================

resource "aws_s3_bucket" "bucket_de_logs" {
  bucket = "mi-bucket-para-auditoria-logs-sre"
}

resource "aws_s3_bucket_public_access_block" "block_public_logs" {
  bucket                  = aws_s3_bucket.bucket_de_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CORREGIDO: El ignore debe ir justo encima de la declaración del recurso
# tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "crypto_logs" {
  bucket = aws_s3_bucket.bucket_de_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_logs" {
  bucket = aws_s3_bucket.bucket_de_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# CORREGIDO: El ignore debe ir justo encima de la declaración del recurso
# tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket_logging" "auditoria_logs" {
  bucket        = aws_s3_bucket.bucket_de_logs.id
  target_bucket = aws_s3_bucket.bucket_de_logs.id
  target_prefix = "self-log/"
}
