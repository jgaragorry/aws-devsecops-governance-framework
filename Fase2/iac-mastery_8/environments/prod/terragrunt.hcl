include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/s3_app" # <-- CORREGIDO: Un solo slash
}

inputs = {
  environment     = "prod"
  vulnerable_mode = false
}
