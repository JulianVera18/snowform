variable "environment" {
  type = string
}

variable "workspace" {
  type = string
}

variable "db_prefix" {
  type = string
}

variable "wh_prefix" {
  type = string
}

variable "sc_prefix" {
  type = string
}

variable "paths" {
  type = object({
    resources = optional(string)
    roles     = optional(string)
    defaults  = optional(string)
  })
}

variable "deploy" {
  type = object({
    resources = object({
      warehouses     = optional(bool)
      databases      = optional(bool)
      schemas        = optional(bool)
      account_roles  = optional(bool)
      database_roles = optional(bool)
      grants         = optional(bool)
    })
  })
}

variable "naming" {
  type = object({
    enabled = bool
    patterns = object({
      warehouses = optional(string)
      databases  = optional(string)
      schemas    = optional(string)
      roles      = optional(string)
    })
  })
}
