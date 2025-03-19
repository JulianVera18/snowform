resource "snowflake_database_role" "role" {
  for_each   = { for role in local.all_database_roles : "${var.db_prefix}_${var.environment}_${role.database}.${role.role}" => role }

  name       = "${each.value.role}"
  database   = "${var.db_prefix}_${var.environment}_${each.value.database}"
}