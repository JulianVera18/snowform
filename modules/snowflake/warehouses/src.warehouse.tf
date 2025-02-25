resource "snowflake_warehouse" "warehouse" {
  for_each                                = {for wh in var.warehouses: wh.name => wh}

  # Required
  name                                    = each.key

  # Optional
  comment                                 = try(each.value.comment, null)
  auto_resume                             = coalesce(each.value.auto_resume, true)
  auto_suspend                            = coalesce(each.value.auto_suspend, 600)
  enable_query_acceleration               = coalesce(each.value.enable_query_acceleration, false)
  initially_suspended                     = try(each.value.initially_suspended, null)
  max_cluster_count                       = coalesce(each.value.max_cluster_count, 1)
  max_concurrency_level                   = try(each.value.max_concurrency_level, null)
  min_cluster_count                       = coalesce(each.value.min_cluster_count, 1)
  query_acceleration_max_scale_factor     = coalesce(each.value.query_acceleration_max_scale_factor, 8)
  resource_monitor                        = try(each.value.resource_monitor, null)
  scaling_policy                          = coalesce(each.value.scaling_policy, "STANDARD")
  statement_queued_timeout_in_seconds     = try(each.value.statement_queued_timeout_in_seconds, null)
  statement_timeout_in_seconds            = try(each.value.statement_timeout_in_seconds, null)
  warehouse_size                          = coalesce(each.value.warehouse_size, "XSMALL")
  warehouse_type                          = coalesce(each.value.warehouse_type, "STANDARD")

  lifecycle {
    prevent_destroy = false
  }
}
