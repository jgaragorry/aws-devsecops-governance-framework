include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${get_terragrunt_dir()}/../../../envcommon/web_app.hcl"
}

inputs = {
  environment   = "dev"
  app_port      = 8080
  html_color    = "#2d3748" # Gris pizarra oscuro
  replica_count = 1
}
