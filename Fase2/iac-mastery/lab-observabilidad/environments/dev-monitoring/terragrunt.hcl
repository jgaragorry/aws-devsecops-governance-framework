include "root" {
  path = find_in_parent_folders("root.hcl")
}
terraform {
  source = "../../modules/stack-monitoreo"
}
inputs = {
  prefijo_entorno        = "dev"
  puerto_grafana_externo = 8085
  version_grafana        = "10.4.1-ubuntu"
}
