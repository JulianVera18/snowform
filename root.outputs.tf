# ROOT OUTPUTS
# ----------------------------------------- #
# output "locals" {
#   description = "local variables in root.main.tf"
#   value = {
#     environment = local.environment
#     team        = local.workspace
#     configs     = local.paths.configs
#     templates   = local.paths.templates
#   }
# }

# SNOWFLAKE OUTPUTS
# ----------------------------------------- #
# output "snowflake" {
#   description = "outputs from snowflake module"
#   value       = module.snowflake
# }

 output "locals" {
   value = {
     # import_files = local.import_files
     imports = local.imports[*]
   }
 }
