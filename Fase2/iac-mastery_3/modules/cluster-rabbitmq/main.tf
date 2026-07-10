terraform {
  required_version = ">= 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Descarga de la imagen oficial con el plugin de administración web preactivado
resource "docker_image" "rabbitmq" {
  name         = "rabbitmq:3.13-management-alpine" # Tag fijo y optimizado en capas
  keep_locally = true                              # 🛡️ Protección de imagen local ante destroys paralelos en WSL
}

# Instanciación del Message Broker con inyección segura de entornos
resource "docker_container" "mq_broker" {
  image = docker_image.rabbitmq.image_id
  name  = var.nombre_mq

  # Hardening SRE: Securizar credenciales por defecto usando variables nativas del contenedor
  env = [
    "RABBITMQ_DEFAULT_USER=${var.rabbitmq_user}",
    "RABBITMQ_DEFAULT_PASS=${var.rabbitmq_pass}"
  ]

  # Mapeo de Puertos Cruzados: AMQP (Mensajes) y Management (Dashboard Web)
  ports {
    internal = 5672
    external = var.puerto_amqp
  }

  ports {
    internal = 15672
    external = var.puerto_management
  }

  # Etiquetas obligatorias para auditoría y costos
  labels {
    label = "environment"
    value = var.entorno
  }
  labels {
    label = "orchestrator"
    value = "terragrunt"
  }
}
