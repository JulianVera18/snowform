resource "snowflake_warehouse" "warehouse" {
  for_each                                = {for wh in var.warehouses: wh.name => wh}

  # Required
  name                                    = each.key

  # Optional
  comment                                 = try(coalesce(each.value.comment, var.defaults.comment), null)
  auto_resume                             = try(coalesce(each.value.auto_resume, var.defaults.auto_resume), true)
  auto_suspend                            = try(coalesce(each.value.auto_suspend,var.defaults.auto_suspend), 600)
  enable_query_acceleration               = try(coalesce(each.value.enable_query_acceleration, var.defaults.enable_query_acceleration), false)
  initially_suspended                     = try(coalesce(each.value.initially_suspended, var.defaults.initially_suspended), null)
  max_cluster_count                       = try(coalesce(each.value.max_cluster_count, var.defaults.max_cluster_count), 1)
  max_concurrency_level                   = try(coalesce(each.value.max_concurrency_level, var.defaults.max_concurrency_level), null)
  min_cluster_count                       = try(coalesce(each.value.min_cluster_count, var.defaults.min_cluster_count), 1)
  query_acceleration_max_scale_factor     = try(coalesce(each.value.query_acceleration_max_scale_factor, var.defaults.query_acceleration_max_scale_factor), 8)
  resource_monitor                        = try(coalesce(each.value.resource_monitor, var.defaults.resource_monitor), null)
  scaling_policy                          = try(coalesce(each.value.scaling_policy, var.defaults.scaling_policy), "STANDARD")
  statement_queued_timeout_in_seconds     = try(coalesce(each.value.statement_queued_timeout_in_seconds, var.defaults.statement_queued_timeout_in_seconds), null)
  statement_timeout_in_seconds            = try(coalesce(each.value.statement_timeout_in_seconds, var.defaults.statement_timeout_in_seconds), null)
  warehouse_size                          = try(coalesce(each.value.warehouse_size, var.defaults.warehouse_size), "XSMALL")
  warehouse_type                          = try(coalesce(each.value.warehouse_type, var.defaults.warehouse_type), "STANDARD")

  lifecycle {
    prevent_destroy = false
  }
}
