resource "docker_image" "nginx_base" {
  name         = "nginx:1.25.4-alpine"
  keep_locally = true # Al destruir el contenedor, conserva la imagen en disco
}

resource "docker_container" "servidor_estatico" {
  name  = "servidor-web-clase"
  image = docker_image.nginx_base.image_id

  ports {
    internal = 80   # Puerto dentro del contenedor
    external = 8080 # Puerto en tu máquina local
  }
}
