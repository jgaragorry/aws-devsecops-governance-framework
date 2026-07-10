include "root" {
  path = find_in_parent_folders("root.hcl")
}
terraform {
  source = "../../modules/stack-monitoreo"
}
inputs = {
  prefijo_entorno        = "prod"
  puerto_grafana_externo = 8086
  version_grafana        = "11.0.0"
}
