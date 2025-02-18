variable "account_roles" {
  type = map(object({
    grant_to    = optional(object({
      roles       = optional(list(string), [])
    }), {})
  }))
}
