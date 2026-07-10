resource "docker_network" "red_monitoreo" {
  name = "${var.prefijo_entorno}-monitoring-network"
}

resource "docker_volume" "prometheus_data" { 
  name = "${var.prefijo_entorno}-prometheus-storage" 
}

resource "docker_volume" "grafana_data" { 
  name = "${var.prefijo_entorno}-grafana-storage" 
}

resource "docker_image" "prometheus_img" { 
  name         = "prom/prometheus:v2.51.0" 
  keep_locally = true 
}

resource "docker_image" "grafana_img" { 
  name         = "grafana/grafana-oss:${var.version_grafana}" 
  keep_locally = true 
}

resource "docker_container" "prometheus" {
  name  = "${var.prefijo_entorno}-prometheus"
  image = docker_image.prometheus_img.image_id
  user  = "root"
  networks_advanced { name = docker_network.red_monitoreo.name }
  mounts {
    target = "/prometheus"
    source = docker_volume.prometheus_data.name
    type   = "volume"
  }
  mounts {
    target = "/etc/prometheus/prometheus.yml"
    source = abspath("${path.module}/config/prometheus.yml")
    type   = "bind"
  }
}

resource "docker_container" "grafana" {
  name  = "${var.prefijo_entorno}-grafana"
  image = docker_image.grafana_img.image_id
  networks_advanced { name = docker_network.red_monitoreo.name }
  ports {
    internal = 3000
    external = var.puerto_grafana_externo
  }
  env = [
    "GF_AUTH_ANONYMOUS_ENABLED=true",
    "GF_AUTH_ANONYMOUS_ORG_ROLE=Admin",
    # 🌟 CORRECCIÓN CRÍTICA: Añadimos la 'S' para cumplir con el criterio estricto de Grafana
    "GF_DATASOURCES_PROMETHEUS_URL=http://${var.prefijo_entorno}-prometheus:9090"
  ]
  mounts {
    target = "/var/lib/grafana"
    source = docker_volume.grafana_data.name
    type   = "volume"
  }
  mounts {
    target = "/etc/grafana/provisioning/datasources/datasources.yaml"
    source = abspath("${path.module}/config/datasources.yaml")
    type   = "bind"
  }
  mounts {
    target = "/etc/grafana/provisioning/dashboards/dashboards.yaml"
    source = abspath("${path.module}/config/dashboards.yaml")
    type   = "bind"
  }
  mounts {
    target = "/var/lib/grafana/dashboards/node-metrics.json"
    source = abspath("${path.module}/config/node-metrics.json")
    type   = "bind"
  }
  depends_on = [docker_container.prometheus]
}
