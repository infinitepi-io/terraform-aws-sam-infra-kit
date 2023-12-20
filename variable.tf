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

variable "ecr_repository_name" {
  type        = string
  validation {
    condition = can(regex("^glg/$", var.ecr_repository_name))
    error_message = "The ECR repository name should start with glg/infrastructure-management-lambda"
  }
  description = "ECR repository to keep the lambda image"
}

variable "custom_policy" {
  type        = map(string)
  default     = {}
  description = "Additional policy required to for the lambda function."
}