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
    condition     = can(regex("^glg\\/[^\\/]+$", var.github_monorepo))
    error_message = "Github mopno repository name should start with glg/"
  }
  description = "GitHub repository name"
}

variable "custom_policy" {
  type        = map(string)
  default     = {}
  description = "Additional policy required to for the lambda function."
}
