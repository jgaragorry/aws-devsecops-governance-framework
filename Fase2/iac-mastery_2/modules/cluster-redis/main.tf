terraform {
  required_version = ">= 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Descarga de la imagen de Base de Datos
resource "docker_image" "redis" {
  name         = "redis:7.2-alpine" # Versión fija y ligera orientada a microservicios
  keep_locally = true               # 🛡️ Mitigación del Race Condition local en WSL
}

# Instanciación del Contenedor con hardening de Base de Datos
resource "docker_container" "redis_db" {
  image = docker_image.redis.image_id
  name  = var.nombre_redis

  # Práctica SRE: Pasar argumentos de configuración directo al motor de Redis
  command = [
    "redis-server",
    "--maxmemory", var.max_memoria,
    "--maxmemory-policy", "allkeys-lru", # Descarte de llaves antiguas si se llena la RAM
    "--protected-mode", "no"
  ]

  ports {
    internal = 6379 # Puerto estándar interno de Redis
    external = var.puerto_host
  }

  # Etiquetas de observabilidad y control de costos
  labels {
    label = "environment"
    value = var.entorno
  }
  labels {
    label = "orchestrator"
    value = "terragrunt"
  }
}
