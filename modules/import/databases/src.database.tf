# values passed as building blocks
resource "snowflake_database" "database" {
  for_each                                       = {for db in var.databases: db.name => db}

  #Required
  name                                           = each.key
 
  #Optional
  comment                                        = try(coalesce(each.value.comment, var.defaults.comment), null)
  is_transient                                   = try(coalesce(each.value.is_transient, var.defaults.is_transient), false)
  data_retention_time_in_days                    = try(coalesce(each.value.data_retention_time_in_days, var.defaults.data_retention_time_in_days), 1)
  max_data_extension_time_in_days                = try(coalesce(each.value.max_data_extension_time_in_days, var.defaults.max_data_extension_time_in_days), null)
  external_volume                                = try(coalesce(each.value.external_volume, var.defaults.external_volume), null)
  catalog                                        = try(coalesce(each.value.catalog, var.defaults.catalog), null)
  replace_invalid_characters                     = try(coalesce(each.value.replace_invalid_characters, var.defaults.replace_invalid_characters), null)
  default_ddl_collation                          = try(coalesce(each.value.default_ddl_collation, var.defaults.default_ddl_collation), null)
  storage_serialization_policy                   = try(coalesce(each.value.storage_serialization_policy, var.defaults.storage_serialization_policy), null)
  log_level                                      = try(coalesce(each.value.log_level, var.defaults.log_level), null)
  trace_level                                    = try(coalesce(each.value.trace_level, var.defaults.trace_level), null)
  suspend_task_after_num_failures                = try(coalesce(each.value.suspend_task_after_num_failures, var.defaults.suspend_task_after_num_failures), null)
  task_auto_retry_attempts                       = try(coalesce(each.value.task_auto_retry_attempts, var.defaults.task_auto_retry_attempts), null)
  user_task_managed_initial_warehouse_size       = try(coalesce(each.value.user_task_managed_initial_warehouse_size, var.defaults.user_task_managed_initial_warehouse_size), null)
  user_task_minimum_trigger_interval_in_seconds  = try(coalesce(each.value.user_task_minimum_trigger_interval_in_seconds, var.defaults.user_task_minimum_trigger_interval_in_seconds), null)
  user_task_timeout_ms                           = try(coalesce(each.value.user_task_timeout_ms, var.defaults.user_task_timeout_ms), null)
  quoted_identifiers_ignore_case                 = try(coalesce(each.value.quoted_identifiers_ignore_case, var.defaults.quoted_identifiers_ignore_case), null)
  enable_console_output                          = try(coalesce(each.value.enable_console_output, var.defaults.enable_console_output), null)

  lifecycle {
    prevent_destroy = false
  }
}
