# validated at account.variables.tf level
variable "warehouses" {
  type = list(object({
    name                      = string
    comment                   = optional(string)
    warehouse_size            = optional(string)
    auto_suspend              = optional(number)
    auto_resume               = optional(bool)
    initially_suspend         = optional(bool)
    max_cluster_count         = optional(number)
    min_cluster_count                   = optional(number)
    scaling_policy                      = optional(string)
    query_acceleration_max_scale_factor = optional(number)
    enable_query_acceleration           = optional(bool)
    warehouse_type                      = optional(string)
  }))

  validation {
    condition = alltrue([
      for wh in var.warehouses:
        !var.naming.enabled ||
        lookup(var.naming.patterns, "warehouses", "") == "" ||
        can(regex(lookup(var.naming.patterns, "warehouses", ""), wh.name))
    ])

    error_message = "warehouse do not follow naming convention ^[A-Z][A-Z0-9_]{3,}_WH$"
  }
}

variable "naming" {
  type = object({
    enabled = bool
    patterns = map(string)
  })
  default = {
    enabled = false
    patterns = {}
  }
}
variable "defaults" {}
