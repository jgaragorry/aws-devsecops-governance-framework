include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${get_terragrunt_dir()}/../../../envcommon/web_app.hcl"
}

inputs = {
  environment   = "prod"
  app_port      = 8080       # Las réplicas se abrirán internamente en 8081 y 8082
  html_color    = "#85144b"  # Rojo Burdeos corporativo
  replica_count = 2
}
