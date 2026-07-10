# Forzar a Terragrunt a usar el binario oficial de Terraform
terraform_binary = "terraform"

locals {
  bucket_name = "sre-linux-mastery-tfstate-2026"
  aws_region  = "us-east-1"
}

# Configuración del backend sin DynamoDB gracias a Terraform 1.10+
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket       = local.bucket_name
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = local.aws_region
    encrypt      = true
    use_lockfile = true # 🎉 ACTIVADO: S3 nativo se encarga del Lock, CERO DynamoDB
  }
}
