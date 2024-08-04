data "aws_region" "lambda_role" {
  provider = aws.lambda_role
}
data "aws_caller_identity" "lambda_role" {
  provider = aws.lambda_role
}
data "aws_partition" "lambda_role" {
  provider = aws.lambda_role
}
data "aws_region" "ecr_repository" {
  provider = aws.ecr_repository
}
data "aws_caller_identity" "ecr_repository" {
  provider = aws.ecr_repository
}
data "aws_partition" "ecr_repository" {
  provider = aws.ecr_repository
}
data "aws_organizations_organization" "primary" {
  provider = aws.lambda_role
}

locals {
  aws_lambda_role = {
    region     = data.aws_region.lambda_role.name
    account_id = data.aws_caller_identity.lambda_role.account_id
    dns_suffix = data.aws_partition.lambda_role.dns_suffix
    partition  = data.aws_partition.lambda_role.partition
  }
  aws_ecr_repository = {
    region     = data.aws_region.ecr_repository.name
    account_id = data.aws_caller_identity.ecr_repository.account_id
    dns_suffix = data.aws_partition.ecr_repository.dns_suffix
    partition  = data.aws_partition.ecr_repository.partition
  }
  org_id = data.aws_organizations_organization.primary.id
  allowed_function_arns = [
    for account_id in var.account_ids : "arn:*:lambda:*:${account_id}:function:${var.name}"
  ]
}
