variable "nombre_contenedor" {
  type        = string
  description = "Nombre único para identificar el contenedor Docker."
}

variable "puerto_externo" {
  type        = number
  description = "Puerto del host que se mapeará al puerto 80 del contenedor."
}

variable "entorno" {
  type        = string
  description = "Nombre del entorno (dev, prod, staging). Usado para observabilidad."
}    
