output "mq_container_id" {
  value       = docker_container.mq_broker.id
  description = "Identificador único del contenedor para auditoría SRE."
}

output "amqp_uri" {
  value       = "amqp://${var.rabbitmq_user}:****@127.0.0.1:${var.puerto_amqp}"
  description = "Cadena de conexión segura para los microservicios Productores/Consumidores."
}

output "management_url" {
  value       = "http://localhost:${var.puerto_management}"
  description = "URL de acceso directo a la consola de administración visual."
}
