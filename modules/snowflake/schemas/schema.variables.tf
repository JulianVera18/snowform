variable "databases" {}
# variable "schemas" {
#   type = list(object({
#     database                                      = string
#     name                                          = string
#     comment                                       = optional(string)
#     catalog                                       = optional(string)
#     data_retention_time_in_days                   = optional(number)
#     default_ddl_collation                         = optional(string)
#     enable_console_output                         = optional(bool)
#     external_volume                               = optional(string)
#     is_transient                                  = optional(bool)
#     log_level                                     = optional(string)
#     max_data_extension_time_in_days               = optional(number)
#     pipe_execution_paused                         = optional(bool)
#     quoted_identifiers_ignore_case                = optional(bool)
#     replace_invalid_characters                    = optional(bool)
#     storage_serialization_policy                  = optional(string)
#     suspend_task_after_num_failures               = optional(number)
#     task_auto_retry_attempts                      = optional(number)
#     trace_level                                   = optional(string)
#     user_task_managed_initial_warehouse_size      = optional(string)
#     user_task_minimum_trigger_interval_in_seconds = optional(number)
#     user_task_timeout_ms                          = optional(number)
#     with_managed_access                           = optional(bool)
#   }))
# }
