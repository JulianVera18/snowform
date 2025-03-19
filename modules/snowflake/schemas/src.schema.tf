resource "snowflake_schema" "schema" {
  for_each                                      = {for schema in local.schemas: "${var.db_prefix}_${var.environment}_${schema.database}.${var.sc_prefix}_${schema.name}" => schema}

  # Required
  database                                      = "${var.db_prefix}_${var.environment}_${each.value.database}"
  name                                          = "${var.sc_prefix}_${each.value.name}"

  # Optional
  comment                                       = try(each.value.comment, null)
  catalog                                       = try(each.value.catalog, null)
  data_retention_time_in_days                   = try(each.value.data_retention_time_in_days, null)
  default_ddl_collation                         = try(each.value.default_ddl_collation, null)
  enable_console_output                         = try(each.value.enable_console_output, null)
  external_volume                               = try(each.value.external_volume, null)
  is_transient                                  = try(each.value.is_transient, false)
  log_level                                     = try(each.value.log_level, null)
  max_data_extension_time_in_days               = try(each.value.max_data_extension_time_in_days, null)
  pipe_execution_paused                         = try(each.value.pipe_execution_paused, null)
  quoted_identifiers_ignore_case                = try(each.value.quoted_identifiers_ignore_case, null)
  replace_invalid_characters                    = try(each.value.replace_invalid_characters, null)
  storage_serialization_policy                  = try(each.value.storage_serialization_policy, null)
  suspend_task_after_num_failures               = try(each.value.suspend_task_after_num_failures, null)
  task_auto_retry_attempts                      = try(each.value.task_auto_retry_attempts, null)
  trace_level                                   = try(each.value.trace_level, null)
  user_task_managed_initial_warehouse_size      = try(each.value.user_task_managed_initial_warehouse_size, null)
  user_task_minimum_trigger_interval_in_seconds = try(each.value.user_task_minimum_trigger_interval_in_seconds, null)
  user_task_timeout_ms                          = try(each.value.user_task_timeout_ms, null)
  with_managed_access                           = try(each.value.with_managed_access, true)

  lifecycle {
    prevent_destroy = true
  }
}
