variable "nombre_contenedor" {
  type        = string
  description = "El nombre descriptivo que se le asignará al contenedor en Docker"
}

variable "version_imagen_alpine" {
  type        = string
  description = "Versión específica y fija de la imagen de Alpine para garantizar inmutabilidad"
}
