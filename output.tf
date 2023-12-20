output "aws" {
  value = local.aws_primary
}

output "lambda_role" {
  value = {
    lambda_role_arn  = aws_iam_role.lambda.arn
    lambda_role_name = aws_iam_role.lambda.name
  }
}

output "ecr_repository" {
  value = {
    ecr_repository_arn  = aws_ecr_repository.this.arn
    ecr_repository_name = aws_ecr_repository.this.name
  }
}
