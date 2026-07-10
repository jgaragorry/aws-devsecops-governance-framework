# Forzar el uso exclusivo del binario oficial de Terraform
terraform_binary = "terraform"

terraform {
  source = "../../modules/stack-aplicacion"
}

inputs = {
  prefijo_entorno    = "dev"
  puerto_web_externo = 8083
  version_postgres   = "15-alpine"
}
