resource "aws_ecr_repository" "this" {
  provider             = aws.ecr_repository
  name                 = "${var.github_monorepo}/${var.name}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository_policy" "this" {
  provider   = aws.ecr_repository
  repository = aws_ecr_repository.this.name
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "LambdaECRImageRetrievalPolicy",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${local.aws_lambda_role.account_id}:root"
        },
        "Action" : "ecr:*"
      },
      {
        "Sid" : "LambdaECRImageRetrievalPolicy",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : [
          "ecr:*",
        ],
        "Condition" : {
          "StringLike" : {
            "aws:sourceArn" : "arn:${local.aws_lambda_role.partition}:lambda:${local.aws_lambda_role.region}:${local.aws_lambda_role.account_id}:function:*"
          }
        }
      }
    ]
  })
}