terraform {
  required_version = ">= 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0" 
    }
  }
}

resource "docker_image" "nginx" {
  # Seguridad: Fijamos una versión específica orientada a producción (Alpine por rendimiento)
  name         = "nginx:1.25.4-alpine"
  keep_locally = true
}

resource "docker_container" "app" {
  image = docker_image.nginx.image_id
  name  = var.nombre_contenedor

  ports {
    internal = 80
    external = var.puerto_externo
  }

  # SRE: Metadatos obligatorios para observabilidad, auditoría y control de costos
  labels {
    label = "environment"
    value = var.entorno
  }
  labels {
    label = "orchestrator"
    value = "terragrunt"
  }
}
