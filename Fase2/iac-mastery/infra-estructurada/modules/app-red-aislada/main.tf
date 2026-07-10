terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.4.0"
    }
  }
}

# 1. Crear una red dedicada para este entorno
resource "docker_network" "red_privada" {
  name = var.nombre_red
}

# 2. Descargar la imagen fija (Buena práctica: sin usar latest)
resource "docker_image" "httpd" {
  name = "httpd:2.4-alpine"
}

# 3. Crear el contenedor y amarrarlo a la red creada arriba
resource "docker_container" "servidor_apache" {
  name  = var.nombre_app
  image = docker_image.httpd.image_id

  # Conexión dinámica a la red usando el nombre del recurso de arriba
  networks_advanced {
    name = docker_network.red_privada.name
  }

  ports {
    internal = 80
    external = var.puerto_externo
  }
}
