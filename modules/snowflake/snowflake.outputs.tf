#  MODULE INPUTS
# ----------------------------------------- #
output "inputs" {
  value = {
    # test = fileset("${var.paths.resources}", "*.yaml")
    # yaml_files = local.yaml_files
    # template_files = local.template_files
    # yaml_to_resources = local.yaml_to_resources
    # resources = local.resources
    # datamarts = local.templates.datamarts
  }
}

#
#   # MODULE PATHS
#   # ----------------------------------------- #
#   output "paths" {
#     value = {
#       root   = path.root
#       module = path.module
#       cwd    = path.cwd
#     }
#   }
#
#
# LOCAL VARIABLES
# ----------------------------------------- #
# output "locals" {
#   value = {
#     files             = local.yaml_files
#     template_files    = local.template_files
#     yaml_to_resources = local.yaml_to_resources
#     resources         = local.resources
#   }
# }

# DATABASE MODULE OUTPUTS
#   ----------------------------------------- #
output "warehouse_module" {
  value = module.warehouse
}

output "database_module" {
  value = module.database
}