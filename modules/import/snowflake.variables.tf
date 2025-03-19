variable "environment" {
  type = string
}

variable "workspace" {
  type = string
}

variable "paths" {
  type = object({
    resources = optional(string)
    roles     = optional(string)
    defaults  = optional(string)
    templates = optional(string)
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

variable "templates" {}