include "root" {
  path = find_in_parent_folders()
}
terraform {
  source = "../../../modules//ssm"
}
inputs = {
  environment      = "dev"
  db_endpoint      = "dev-cluster-rds.sre.local"
  # Variables FinOps diferenciadas
  crear_base_datos = true
  instancia_db     = "db.t3.micro" # Instancia pequeña para desarrollo
}
