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
  nombre_mq         = "sre-mq-dev"
  puerto_amqp       = 5672          # Puerto AMQP estándar
  puerto_management = 15672         # Consola estándar
  rabbitmq_user     = "dev_admin"
  rabbitmq_pass     = "dev_secret_pass_2026"
  entorno           = local.entorno
}
