variable "nombre_mq" {
  type        = string
  description = "Nombre único de identificación para el contenedor RabbitMQ."
}

variable "puerto_amqp" {
  type        = number
  description = "Puerto externo para el protocolo de mensajería AMQP del broker."
}

variable "puerto_management" {
  type        = number
  description = "Puerto externo para acceder a la interfaz web de administración visual."
}

variable "rabbitmq_user" {
  type        = string
  description = "Usuario administrador por defecto (Hardening de Seguridad)."
}

variable "rabbitmq_pass" {
  type        = string
  description = "Contraseña administrativa por defecto (Hardening de Seguridad)."
  sensitive   = true
}

variable "entorno" {
  type        = string
  description = "Etiqueta identificadora del ciclo de vida del entorno."
}
