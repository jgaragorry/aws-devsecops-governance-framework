include "root" {
  path = "../../../terragrunt.hcl"
}

locals {
  env_vars = read_terragrunt_config("../env.hcl")
  entorno  = local.env_vars.locals.env
}

terraform {
  source = "../../../modules//cluster-rabbitmq"
}

inputs = {
  nombre_mq         = "sre-mq-prod"
  puerto_amqp       = 5673          # Puerto aislado para evitar colisión de red
  puerto_management = 15673         # Consola aislada para evitar colisión de red
  rabbitmq_user     = "prod_cluster_boss"
  rabbitmq_pass     = "prod_ultra_secure_password_2026"
  entorno           = local.entorno
}
