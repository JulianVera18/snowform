# ROOT OUTPUTS
# ----------------------------------------- #
# output "locals" {
#   value = {
#     environment = local.environment
#     team        = local.workspace
#     configs     = local.paths.configs
#     templates   = local.paths.templates
#   }
# }

# SNOWFLAKE OUTPUTS
# ----------------------------------------- #
output "snowflake" {
  value       = module.snowflake
}

 # output "locals" {
 #   value = {
 #     import_files = local.import_files
 #     imports = local.imports[*]
 #   }
 # }