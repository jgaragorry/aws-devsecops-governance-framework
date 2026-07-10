variable "prefijo_entorno" {
  type        = string
  description = "Prefijo para identificar el entorno (dev o prod)"
}
variable "puerto_grafana_externo" {
  type        = number
  description = "Puerto en la máquina host para acceder a Grafana"
}
variable "version_grafana" {
  type        = string
  description = "Versión fija de Grafana"
}
