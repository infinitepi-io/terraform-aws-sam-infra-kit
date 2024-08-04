# name and tags are common variables but don't need to exist

variable "name" {
  type = string
  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The 'name' cannot be empty."
  }
  description = <<-DOC
  'name' will at least in part be assigned to most resources
  DOC
}

variable "github_monorepo" {
  type = string
  validation {
    condition     = can(regex("^infinitepi-io\\/[^\\/]+$", var.github_monorepo))
    error_message = "Github mopno repository name should start with infinitepi-io/"
  }
  description = "GitHub repository name"
}

variable "custom_policy" {
  type        = map(string)
  default     = {}
  description = "Additional policy required to for the lambda function."
}
variable "account_ids" {
  type = list(string)
  default = [
    "158710814571"
  ]
  description = "A list of accounts to give access to multiple account lambda deployment using the same ecr image."
}
variable "ecr_creation" {
  type        = bool
  default     = false
  description = "Use this flag to create ecr repository and policy."
}
