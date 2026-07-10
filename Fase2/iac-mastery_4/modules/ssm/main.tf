terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Recurso Base (Parámetro SSM gratuito)
resource "aws_ssm_parameter" "db_host" {
  name        = "/config/${var.environment}/database_url"
  description = "URL de conexión de base de datos para ${var.environment}"
  type        = "String"
  value       = var.db_endpoint
  tags = {
    Environment = var.environment
    ManagedBy   = "Terragrunt"
    Lab         = "iac-mastery_4"
  }
}

# --- 💰 RECURSO ADICIONAL PARA SIMULACIÓN DE COSTOS FINOPS ---
resource "aws_db_instance" "simulada" {
  count                = var.crear_base_datos ? 1 : 0 # 0 = No crea nada / 1 = Despliega recurso
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = var.instancia_db
  username             = "admin"
  password             = "PasswordSegura123!"
  skip_final_snapshot  = true

  tags = {
    Name        = "db-simulada-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terragrunt"
  }
}
