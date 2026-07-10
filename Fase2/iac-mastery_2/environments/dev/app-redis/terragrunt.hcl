include "root" {
  path = "../../../terragrunt.hcl"
}

locals {
  env_vars = read_terragrunt_config("../env.hcl")
  entorno  = local.env_vars.locals.env
}

# Doble barra obligatoria para indicación de subdirectorio local
terraform {
  source = "../../../modules//cluster-redis"
}

inputs = {
  nombre_redis = "sre-redis-dev"
  puerto_host  = 6379           # Puerto por defecto para desarrollo
  max_memoria  = "128mb"        # Perfil bajo de recursos para pruebas
  entorno      = local.entorno
}
