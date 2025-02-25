# output "locals" {
#   value = {
#     all_roles          = local.all_roles
#     all_database_roles = local.all_database_roles
#     grants             = local.grants
#     privileges     = {
#       database = local.database_privileges
#       schema   = local.schema_privileges
#     }
#   }
# }

output "schemas" {
  value = flatten([
    for db in var.databases[*]: [for schema in lookup(db, "schemas"): merge(schema, { "database" = db.name })]
  ])
}
