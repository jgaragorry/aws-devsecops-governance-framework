# Forzar el uso exclusivo del binario oficial de Terraform
terraform_binary = "terraform"

terraform {
  source = "../../modules/stack-aplicacion"
}

inputs = {
  prefijo_entorno    = "prod"
  puerto_web_externo = 8084
  version_postgres   = "16.2-alpine"
}
