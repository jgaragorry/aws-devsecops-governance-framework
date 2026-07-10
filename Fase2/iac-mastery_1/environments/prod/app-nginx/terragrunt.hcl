# 1. Incluye el archivo raíz de manera estática y directa
include "root" {
  path = "../../../terragrunt.hcl"
}

# 2. Leemos el contexto de entorno de manera directa apuntando al archivo relativo de PROD
locals {
  env_vars = read_terragrunt_config("../env.hcl")
  entorno  = local.env_vars.locals.env
}

# 3. Módulo base a instanciar (Mismo módulo reutilizado)
terraform {
  source = "../../../modules//contenedor-base"
}

# 4. Parámetros de configuración específicos para PROD
inputs = {
  nombre_contenedor = "sre-app-nginx-prod"
  puerto_externo    = 8082
  entorno           = local.entorno
}
