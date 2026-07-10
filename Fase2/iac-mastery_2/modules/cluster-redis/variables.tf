variable "nombre_redis" {
  type        = string
  description = "Nombre único de identificación para la base de datos Redis."
}

variable "puerto_host" {
  type        = number
  description = "Puerto externo expuesto en la máquina local (WSL) para conectarse a Redis."
}

variable "max_memoria" {
  type        = string
  description = "Límite estricto de memoria asignado a Redis (Práctica de Capacidad SRE)."
}

variable "entorno" {
  type        = string
  description = "Etiqueta identificadora del ciclo de vida del entorno."
}
