# Práctica de Gobernanza: Forzar el uso del binario oficial de Terraform 
terraform_binary = "terraform"

# 1. Generación automática y dinámica del bloque Provider
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "docker" {
  host = "unix:///var/run/docker.sock"
}
EOF
}

# En el raíz ya no buscamos "env.hcl" hacia arriba. 
# Dejamos que las hojas le pasen sus propios contextos si es necesario,
# o usamos interpolación limpia en las hojas.
