terraform {
  required_version = ">= 1.7.4"
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
    }
  }
}

locals {

  # ACCOUNT ROLES [from rbac/${workspace}/*]
  # ------------------------
  hyerarchy  = try(yamldecode(file("${path.root}/environments/${var.environment}/workspaces/${var.workspace}/roles/account.role.yaml")), {})
  privileges = try(yamldecode(file("${path.root}/environments/${var.environment}/workspaces/${var.workspace}/roles/privileges.yaml")), {})

  all_roles      = try(local.hyerarchy.roles, {})
  all_privileges = try(local.privileges.privileges, {})
  system_roles   = try(local.hyerarchy.system_roles, {})
  # ownership_roles = try(local.hyerarchy.ownership_roles, {})

  grants  = flatten([
    for parent_role, childs in transpose(local.all_roles): [
      for child_role in childs: {
        parent = parent_role
        child  = child_role
      }
    ]
  ])

  system_grants  = flatten([
    for parent_role, childs in transpose(local.system_roles): [
      for child_role in childs: {
        parent = parent_role
        child  = child_role
      }
    ]
  ])
  # database_privileges = flatten([
  #   for schema in var.schemas: flatten([
  #     for role_name, privs in transpose(local.all_privileges.database): {
  #       role = "${schema.name}_${role_name}"
  #       privileges = privs
  #       database = schema.database
  #     }
  #   ])
  # ])
  #
  # schema_privileges = flatten([
  #   for schema in var.schemas: flatten([
  #     for role_name, privs in transpose(local.all_privileges.schema): {
  #       role = "${schema.name}_${role_name}"
  #       privileges = privs
  #       database = schema.database
  #       schema = schema.name
  #     }
  #   ])
  # ])
}

