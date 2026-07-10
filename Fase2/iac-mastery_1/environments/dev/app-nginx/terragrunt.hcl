# 1. Incluye el archivo raíz de manera estática y directa
include "root" {
  path = "../../../terragrunt.hcl"
}

# 2. Leemos el contexto de entorno de manera directa apuntando al archivo relativo
locals {
  env_vars = read_terragrunt_config("../env.hcl")
  entorno  = local.env_vars.locals.env
}

# 3. Módulo base a instanciar
terraform {
  source = "../../../modules//contenedor-base"
}

# 4. Parámetros de configuración
inputs = {
  nombre_contenedor = "sre-app-nginx-dev"
  puerto_externo    = 8081
  entorno           = local.entorno
}
