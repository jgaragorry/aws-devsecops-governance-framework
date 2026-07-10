include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/s3_app" # <-- CORREGIDO: Un solo slash
}

inputs = {
  environment     = "dev"
  vulnerable_mode = false
}
