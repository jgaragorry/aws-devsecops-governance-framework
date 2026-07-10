# modules/infra/main.tf

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

variable "environment"   { type = string }
variable "app_port"      { type = number }
variable "html_color"    { type = string }
variable "replica_count" { type = number }

# ==========================================
# 🐳 INFRAESTRUCTURA LOCAL: DOCKER
# ==========================================

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true # <--- Cambiar de false a true
}

# Servidores Web de la Aplicación
resource "docker_container" "web" {
  count = var.replica_count
  name  = "web-${var.environment}-${count.index}"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    # Si es PROD, abre dinámicamente los puertos correlativos (8081, 8082...) para el LB
    external = var.environment == "prod" ? (var.app_port + count.index + 1) : var.app_port
  }
  
  # Comando inline directo y limpio para Docker
  command = [
    "sh", "-c",
    "echo '<html><body style=\"background-color:${var.html_color}; color:white; font-family:sans-serif; text-align:center; padding-top:10%;\"><h1>Entorno: ${upper(var.environment)}</h1><p>ID Instancia: ${count.index}</p></body></html>' > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"
  ]
}

# Balanceador Nginx local (Exclusivo para simular Producción en Alta Disponibilidad)
resource "docker_container" "lb" {
  count = var.environment == "prod" ? 1 : 0
  name  = "lb-prod"
  image = docker_image.nginx.image_id
  
  # Expuesto directamente en el puerto 80 estándar de Windows/WSL
  ports {
    internal = 80
    external = 80
  }
  
  command = [
    "sh", "-c",
    "echo 'events {} http { upstream app { server 172.17.0.1:8081; server 172.17.0.1:8082; } server { listen 80; location / { proxy_pass http://app; } } }' > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"
  ]
}
