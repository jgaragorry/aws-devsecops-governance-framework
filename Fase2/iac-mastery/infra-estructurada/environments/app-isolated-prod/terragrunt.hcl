# Línea 1: Atributo global, completamente afuera de cualquier bloque
terraform_binary = "terraform"

terraform {
  source = "../../modules/app-red-aislada"
}

inputs = {
  nombre_red     = "red-segura-prod"
  nombre_app     = "apache-prod"
  puerto_externo = 8092
}
