# Línea 1: Atributo global, completamente afuera de cualquier bloque
terraform_binary = "terraform"

terraform {
# Apuntamos al nuevo módulo de red aislada
  source = "../../modules/app-red-aislada"
}

inputs = {
  nombre_red     = "red-interna-dev"
  nombre_app     = "apache-dev"
  puerto_externo = 8091
}
