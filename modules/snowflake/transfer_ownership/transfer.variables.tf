variable "ownership_role" {
  description = "Rol al que se transferirá el ownership de los objetos"
  type        = string
}

variable "environment" {
  description = "Ambiente (DEV, PROD, etc.)"
  type        = string
}

variable "wh_prefix" {
  description = "Prefijo para warehouses"
  type        = string
}

variable "db_prefix" {
  description = "Prefijo para bases de datos"
  type        = string
}

variable "sc_prefix" {
  description = "Prefijo para schemas"
  type        = string
}

# Los mapas/objetos resultantes de los módulos anteriores:
variable "warehouses" {
  description = "Mapa de warehouses creados"
  type        = any
}

variable "databases" {
  description = "Mapa de databases creadas"
  type        = any
}

variable "schemas" {
  description = "Mapa de schemas creados"
  type        = any
}
