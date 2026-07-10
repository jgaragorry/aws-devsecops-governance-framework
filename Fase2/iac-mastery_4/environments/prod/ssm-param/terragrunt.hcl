include "root" {
  path = find_in_parent_folders()
}
terraform {
  source = "../../../modules//ssm"
}
inputs = {
  environment      = "prod"
  db_endpoint      = "prod-main-cluster-ha.aws.com"
  # Variables FinOps diferenciadas
  crear_base_datos = true
  instancia_db     = "db.m5.large" # Instancia de producción corporativa (Cara)
}
