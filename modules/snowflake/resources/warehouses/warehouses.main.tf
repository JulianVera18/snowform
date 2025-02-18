resource "snowflake_warehouse" "warehouse" {
  for_each                                                  = { for wh in var.warehouses : wh.name => wh }

  # Required
  name                                                      = each.value.name

  # Optional
  comment                                                   = try(each.value.comment, null)
  auto_resume                                               = try(each.value.auto_resume, null)
  auto_suspend                                              = try(each.value.auto_suspend, null)
  enable_query_acceleration                                 = try(each.value.enable_query_acceleration, null)
  initially_suspended                                       = try(each.value.initially_suspended, null)
  max_cluster_count                                         = try(each.value.max_cluster_count, null)
  max_concurrency_level                                     = try(each.value.max_concurrency_level, null)
  min_cluster_count                                         = try(each.value.min_cluster_count, null)
  query_acceleration_max_scale_factor                       = try(each.value.query_acceleration_max_scale_factor, null)
  resource_monitor                                          = try(each.value.resource_monitor, null)
  scaling_policy                                            = try(each.value.scaling_policy, null)
  statement_queued_timeout_in_seconds                       = try(each.value.statement_queued_timeout_in_seconds, null)
  statement_timeout_in_seconds                              = try(each.value.statement_timeout_in_seconds, null)
  warehouse_size                                            = try(each.value.warehouse_size, null)
  warehouse_type                                            = try(each.value.warehouse_type, null)

  lifecycle {
    prevent_destroy = false
  }
}
