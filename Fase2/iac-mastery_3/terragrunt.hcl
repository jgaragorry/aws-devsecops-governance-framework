# Práctica de Gobernanza: Forzar el uso del binario oficial de Terraform
# Blindaje absoluto contra ejecuciones cruzadas por defecto de OpenTofu en el PATH
terraform_binary = "terraform"

# Generación dinámica del proveedor de Docker en cada hoja de entorno
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "docker" {
  host = "unix:///var/run/docker.sock"
}
EOF
}
