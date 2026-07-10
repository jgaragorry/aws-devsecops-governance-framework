terraform {
  required_version = ">= 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

# 1. Crear la red privada aislada para el entorno
resource "docker_network" "red_privada" {
  name = "${var.prefijo_entorno}-network"
}

# 2. Descargar las imágenes inmutables parches de seguridad al día
resource "docker_image" "postgres_img" {
  name         = "postgres:${var.version_postgres}"
  keep_locally = true
}

resource "docker_image" "nginx_img" {
  name         = "nginx:1.27.0-alpine"
  keep_locally = true
}

# 3. Contenedor de Base de Datos (PostgreSQL)
resource "docker_container" "db_server" {
  name  = "${var.prefijo_entorno}-postgres-db"
  image = docker_image.postgres_img.image_id
  
  env = [
    "POSTGRES_PASSWORD=SreMasterSecretPass",
    "POSTGRES_USER=sre_admin",
    "POSTGRES_DB=telemetria_db"
  ]

  networks_advanced {
    name = docker_network.red_privada.name
  }
}

# 4. Contenedor de la Aplicación Web (Nginx Frontend)
resource "docker_container" "web_server" {
  name  = "${var.prefijo_entorno}-frontend-app"
  image = docker_image.nginx_img.image_id

  networks_advanced {
    name = docker_network.red_privada.name
  }

  ports {
    internal = 80
    external = var.puerto_web_externo
  }

  # Control SRE: Forzamos la creación secuencial ordenada
  depends_on = [docker_container.db_server]
}
