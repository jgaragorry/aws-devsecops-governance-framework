output "redis_container_id" {
  value       = docker_container.redis_db.id
  description = "Identificador único de auditoría de la base de datos."
}

output "redis_endpoint" {
  value       = "redis://127.0.0.1:${var.puerto_host}"
  description = "Cadena de conexión directa para los microservicios."
}
