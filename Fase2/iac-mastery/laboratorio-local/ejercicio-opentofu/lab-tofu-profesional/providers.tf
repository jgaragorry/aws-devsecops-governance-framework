terraform {
  # Fijamos la versión de OpenTofu
  required_version = ">= 1.8.0"

  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      # Usamos la versión moderna totalmente compatible y firmada para OpenTofu
      version = "4.4.0"
    }
  }
}

# Configuración del proveedor de Docker
provider "docker" {
  host = "unix:///var/run/docker.sock"
}
