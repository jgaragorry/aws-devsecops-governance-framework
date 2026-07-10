# 1. Definir el Proveedor (El traductor que interactúa con Docker)
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# 2. Descargar la imagen de Nginx desde Docker Hub
resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}

# 3. Crear y encender el contenedor usando la imagen descargada
resource "docker_container" "nginx_server" {
  image = docker_image.nginx_image.image_id
  name  = "servidor-web-clase"

  ports {
    internal = 80
    external = 8080
  }
}
