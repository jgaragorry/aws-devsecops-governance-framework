# Definición de la Imagen de Docker usando una versión explícita y segura
resource "docker_image" "alpine_image" {
  name         = "alpine:${var.version_imagen_alpine}"
  keep_locally = false
}

# Definición del Contenedor de Docker
resource "docker_container" "alpine_container" {
  image   = docker_image.alpine_image.image_id
  name    = var.nombre_contenedor
  command = ["tail", "-f", "/dev/null"]
}
