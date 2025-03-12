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

output "defaults" {
  value = var.defaults
}

output "databases" {
  description = "Mapa de bases de datos creadas, con su nombre, id, comentario y demás atributos relevantes"
  value = {
    for key, db in snowflake_database.database :
    key => {
      name         = db.name
      id           = db.id
      comment      = db.comment
      is_transient = db.is_transient
    }
  }
}