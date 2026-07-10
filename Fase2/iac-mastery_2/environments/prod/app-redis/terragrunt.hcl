include "root" {
  path = "../../../terragrunt.hcl"
}

locals {
  env_vars = read_terragrunt_config("../env.hcl")
  entorno  = local.env_vars.locals.env
}

terraform {
  source = "../../../modules//cluster-redis"
}

inputs = {
  nombre_redis = "sre-redis-prod"
  puerto_host  = 6380           # Aislamiento de red: Puerto alternativo para producción
  max_memoria  = "512mb"        # Mayor capacidad reservada para carga real
  entorno      = local.entorno
}
