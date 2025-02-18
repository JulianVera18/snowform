variable "warehouses" {}

# variable "warehouses" {
#   type = object({
#     name                      = optional(string)
#     comment                   = optional(string)
#     warehouse_size            = optional(string)
#     auto_suspend              = optional(number)
#     auto_resume               = optional(bool)
#     initially_suspend         = optional(bool)
#     max_cluster_count         = optional(number)
#     min_cluster_count         = optional(number)
#     scaling_policy            = optional(string)
#     enable_query_acceleration = optional(bool)
#     warehouse_type            = optional(string)
#   })
# }
