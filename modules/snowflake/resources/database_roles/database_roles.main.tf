locals {
  # Extract YAMLs
  privileges_yaml = yamldecode(file("${path.root}/${var.privileges_file}"))
  hierarchy_yaml  = yamldecode(file("${path.root}/${var.hierarchy_file}"))

  # Database roles
  database_roles           = compact(concat(local.privileges_yaml.database.roles, local.privileges_yaml.schema.roles))
  database_roles_hierarchy = local.hierarchy_yaml.database.hierarchy

  all_database_roles = {
    for item in flatten([
      for schema in var.schemas_fqn : [
        for role_name in local.database_roles : {
          role_name      = "${schema.dbrole_prefix}_${role_name}"
          database       = schema.database
          schema         = schema.schema
          schema_fqn     = schema.fully_qualified_name
          prefix         = schema.dbrole_prefix
          role_name_base = role_name
        }
      ]
    ]) : item.role_name => item
  }

  hierarchy_map = flatten([
    for role_name, role in local.all_database_roles : [
      for parent in lookup(local.database_roles_hierarchy, role.role_name_base, []) : {
        database = role.database
        child    = role.role_name
        parent   = "${role.prefix}_${parent}"
      }
    ] if length(lookup(local.database_roles_hierarchy, role.role_name_base, [])) > 0
  ])

  database_privileges = merge([
    for schema in var.schemas_fqn : {
      for role, privs in transpose(local.privileges_yaml.database.privileges) : "${schema.dbrole_prefix}_${role}" =>
      {
        database   = schema.database
        privileges = privs
      }
    }
  ]...)

  schema_privileges = merge([
    for schema in var.schemas_fqn : {
      for role, privs in transpose(local.privileges_yaml.schema.privileges) : "${schema.dbrole_prefix}_${role}" => 
      {
        database   = schema.database
        privileges = privs
      }
    }
  ]...)

}

resource "snowflake_database_role" "role" {
  for_each            = { for role in local.all_database_roles : role.role_name => role }

  name                = each.value.role_name
  database            = each.value.database
}

resource "snowflake_grant_database_role" "grants_to" {
  for_each                  = { for role in local.hierarchy_map : "${role.child}|${role.parent}" => role }

  database_role_name        = "${each.value.database}.${each.value.child}"
  parent_database_role_name = "${each.value.database}.${each.value.parent}"

  depends_on          = [snowflake_database_role.role]
}

resource "snowflake_grant_privileges_to_database_role" "database_privileges" {
  for_each            = local.database_privileges

  on_database         = local.all_database_roles[each.key].database
  # database_role_name  = "\"${each.value.database}\".\"${each.key}\""
  database_role_name  = snowflake_database_role.role[each.key].fully_qualified_name
  privileges          = each.value.privileges

  depends_on          = [
    snowflake_database_role.role,
    snowflake_grant_database_role.grants_to
  ]
}

 resource "snowflake_grant_privileges_to_database_role" "schema_privileges" {
   for_each            = local.schema_privileges

   # database_role_name  = "\"${each.value.database}\".\"${each.key}\""
   database_role_name  = snowflake_database_role.role[each.key].fully_qualified_name
   privileges          = each.value.privileges

   on_schema {
     schema_name = local.all_database_roles[each.key].schema_fqn
   }

   depends_on = [
     snowflake_database_role.role,
     snowflake_grant_database_role.grants_to,
     snowflake_grant_privileges_to_database_role.database_privileges
   ]
 }
