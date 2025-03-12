variable "db_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "defaults" {}

variable "databases" {}

# variable "ownership_role" {
#   type = string
# }

# variable "databases" {
#   type = list(object({
#     name                                          = string
#     comment                                       = optional(string)
#     is_transient                                  = optional(bool)
#     data_retention_time_in_days                   = optional(number)
#     max_data_extension_time_in_days               = optional(number)
#     external_volume                               = optional(string)
#     catalog                                       = optional(string)
#     replace_invalid_characters                    = optional(bool)
#     default_ddl_collation                         = optional(string)
#     storage_serialization_policy                  = optional(string)
#     log_level                                     = optional(string)
#     trace_level                                   = optional(string)
#     suspend_task_after_num_failures               = optional(number)
#     task_auto_retry_attempts                      = optional(number)
#     user_task_managed_initial_warehouse_size      = optional(string)
#     user_task_minimum_trigger_interval_in_seconds = optional(number)
#     user_task_timeout_ms                          = optional(number)
#     quoted_identifiers_ignore_case                = optional(bool)
#     enable_console_output                         = optional(bool)
#     schemas                                       = optional(list(any), [])
#   }))
# }
