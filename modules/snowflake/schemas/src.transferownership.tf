# resource "snowflake_grant_ownership" "transfer_database_ownership" {
#   for_each = {for schema in local.schemas: "${var.db_prefix}_${var.environment}_${schema.database}.${var.sc_prefix}_${schema.name}" => schema}

#   account_role_name = "${var.environment}_${var.ownership_role}"
#   on {
#     object_type = "SCHEMA"
#     object_name = each.key
#   }
# }
