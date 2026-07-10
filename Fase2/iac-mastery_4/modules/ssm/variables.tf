variable "environment" {
  type        = string
  description = "Entorno (dev/prod)"
}

variable "db_endpoint" {
  type        = string
  description = "Endpoint de la Base de Datos para inyectar"
}

# --- 🌟 NUEVAS VARIABLES OPTIONALES FINOPS (NO ROMPEN NADA) ---
variable "crear_base_datos" {
  type        = bool
  default     = false # Si no se especifica, no creará la DB cara, protegiendo tu lab
  description = "Controlador condicional para simular costos con Infracost"
}

variable "instancia_db" {
  type        = string
  default     = "db.t3.micro"
  description = "Tipo de instancia de base de datos para simular en el entorno"
}
