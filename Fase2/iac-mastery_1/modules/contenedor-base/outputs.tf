output "container_id" {
  value       = docker_container.app.id
  description = "ID único del contenedor generado por Docker."
}

output "external_port" {
  value       = var.puerto_externo
  description = "Puerto expuesto en el host para verificar conectividad."
}
