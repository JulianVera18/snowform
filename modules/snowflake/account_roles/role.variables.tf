variable "roles" {
  description = "All roles configuration including privileges"
  type = object({
    system_role     = optional(list(object({
      name     = string
      account  = optional(list(string), [])
      database = optional(any)  # Ajusta según corresponda
      privileges = optional(list(any), [])
    })), [])
    ownership_roles = optional(map(list(string)), {})
    account = optional(list(object({
      name     = string
      account  = optional(list(string), [])
      database = map(list(string))
      privileges = optional(list(object({
        type              = string
        privileges        = optional(list(string), [])
        all_privileges    = optional(bool, false)
        with_grant_option = optional(bool, false)
        always_apply      = optional(bool, false)
        on_account        = optional(bool, false)
        on_account_object = optional(object({
          object_type = string
          object_name = string
        }))
        on_schema         = optional(object({
          schema_name                = optional(string)
          all_schemas_in_database    = optional(string)
          future_schemas_in_database = optional(string)
        }))
        on_schema_object  = optional(object({
          object_type = optional(string)
          object_name = optional(string)
          all         = optional(object({
            object_type_plural = string
            in_database        = optional(string)
            in_schema          = optional(string)
          }))
          future      = optional(object({
            object_type_plural = string
            in_database        = optional(string)
            in_schema          = optional(string)
          }))
        }))
      })), [])
    })), [])
  })
  default = null
}

variable "privileges" {
  type    = any
}

variable "environment" {}
variable "db_prefix" {}
variable "wh_prefix" {}