# resource "snowflake_grant_ownership" "transfer_database_ownership" {
#   for_each = { for db in var.databases : "${var.db_prefix}_${var.environment}_${db.name}" => db }

#   account_role_name = "${var.environment}_${var.ownership_role}"
#   on {
#     object_type = "DATABASE"
#     object_name = each.key
#   }
# }
