output "lambda_role" {
  value = {
    lambda_role_arn  = aws_iam_role.lambda.arn
    lambda_role_name = aws_iam_role.lambda.name
  }
}

output "ecr_repository" {
  value = {
    ecr_repository_arn  = var.ecr_creation == true ? aws_ecr_repository.this[0].arn : "skipped_ecr_creation"
    ecr_repository_name = var.ecr_creation == true ? aws_ecr_repository.this[0].name : "skipped_ecr_creation"
  }
}
