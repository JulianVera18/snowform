resource "snowflake_database" "database" {
  for_each                                       = {for db in var.databases: db.name => db}

  #Required
  name                                           = "${var.db_prefix}_${var.environment}_${each.key}"
 
  #Optional
  comment                                        = try(each.value.comment, null)
  is_transient                                   = try(each.value.is_transient, false)
  data_retention_time_in_days                    = try(each.value.data_retention_time_in_days, 1)
  max_data_extension_time_in_days                = try(each.value.max_data_extension_time_in_days, null)
  external_volume                                = try(each.value.external_volume, null)
  catalog                                        = try(each.value.catalog, null)
  replace_invalid_characters                     = try(each.value.replace_invalid_characters, null)
  default_ddl_collation                          = try(each.value.default_ddl_collation, null)
  storage_serialization_policy                   = try(each.value.storage_serialization_policy, null)
  log_level                                      = try(each.value.log_level, null)
  trace_level                                    = try(each.value.trace_level, null)
  suspend_task_after_num_failures                = try(each.value.suspend_task_after_num_failures, null)
  task_auto_retry_attempts                       = try(each.value.task_auto_retry_attempts, null)
  user_task_managed_initial_warehouse_size       = try(each.value.user_task_managed_initial_warehouse_size, null)
  user_task_minimum_trigger_interval_in_seconds  = try(each.value.user_task_minimum_trigger_interval_in_seconds, null)
  user_task_timeout_ms                           = try(each.value.user_task_timeout_ms, null)
  quoted_identifiers_ignore_case                 = try(each.value.quoted_identifiers_ignore_case, null)
  enable_console_output                          = try(each.value.enable_console_output, null)

  lifecycle {
    prevent_destroy = false
  }
}
