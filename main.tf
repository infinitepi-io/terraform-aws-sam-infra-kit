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
}
