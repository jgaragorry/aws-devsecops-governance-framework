# root.hcl

# Forzar el uso del binario oficial de HashiCorp Terraform
terraform_binary = "/usr/bin/terraform"

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "docker" {
  host = "unix:///var/run/docker.sock"
}
EOF
}
