variable "nombre_red" {
  type        = string
  description = "Nombre de la red aislada de Docker"
}

variable "nombre_app" {
  type        = string
  description = "Nombre del contenedor de la aplicación"
}

variable "puerto_externo" {
  type        = number
  description = "Puerto de salida en la máquina host"
}
