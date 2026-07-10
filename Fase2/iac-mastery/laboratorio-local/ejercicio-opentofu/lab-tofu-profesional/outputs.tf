output "contenedor_id" {
  value       = docker_container.alpine_container.id
  description = "El ID único generado por Docker para este contenedor"
}

output "nombre_contenedor_creado" {
  value       = docker_container.alpine_container.name
  description = "El nombre oficial asignado al contenedor en la ejecución"
}
