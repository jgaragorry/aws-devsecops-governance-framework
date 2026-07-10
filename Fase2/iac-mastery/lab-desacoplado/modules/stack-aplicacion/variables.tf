variable "prefijo_entorno" {
  type        = string
  description = "Prefijo para identificar el entorno (dev o prod)"
}

variable "puerto_web_externo" {
  type        = number
  description = "Puerto en la máquina host para acceder a la App Web"
}

variable "version_postgres" {
  type        = string
  description = "Versión específica e inmutable para el motor de Base de Datos"
}
