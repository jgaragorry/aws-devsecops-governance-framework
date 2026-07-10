terraform_binary = "terraform"

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = "terraform {\n  required_version = \">= 1.5.0\"\n  required_providers {\n    docker = {\n      source  = \"kreuzwerker/docker\"\n      version = \"~> 3.0.2\"\n    }\n  }\n}\nprovider \"docker\" {\n  host = \"unix:///var/run/docker.sock\"\n}"
}
