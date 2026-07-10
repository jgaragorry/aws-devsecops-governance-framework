# Forzar el uso del binario oficial de HashiCorp Terraform
terraform_binary = "/usr/local/bin/terraform"

remote_state {
  backend = "s3"
  config = {
    bucket  = get_env("TG_AWS_BUCKET")
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = "terraform {\n  required_version = \">= 1.15.7\"\n}\nprovider \"aws\" {\n  region = \"us-east-1\"\n}\nprovider \"azurerm\" {\n  features {}\n}"
}
