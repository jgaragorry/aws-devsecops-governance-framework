variable "nombre_contenedor" {
  type        = string
  description = "El nombre que tendrá el contenedor de Nginx"
}

variable "puerto_externo" {
  type        = number
  description = "Puerto de tu máquina local para acceder a la aplicación"
}
