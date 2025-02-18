output "locals" {
  value = {
   # hierarchy_file = local.hierarchy_file
    # privileges_file = local.privileges_file
    hierarchy_map       = local.hierarchy_map
    all_database_roles  = local.all_database_roles
    database_privileges = local.database_privileges
  }
}

output "roles" {
  value = {for k,v in snowflake_database_role.role : k => v}
}

output "grants_to" {
  value = {for k,v in snowflake_grant_database_role.grants_to : k => v}
}
