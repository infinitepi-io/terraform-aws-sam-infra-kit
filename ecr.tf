resource "aws_ecr_repository" "this" {
  provider             = aws.secondary
  name                 = "${var.github_monorepo}/${var.name}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository_policy" "this" {
  provider   = aws.secondary
  repository = aws_ecr_repository.this.name
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "LambdaECRImageRetrievalPolicy",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:DeleteRepositoryPolicy",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:SetRepositoryPolicy"
        ],
        "Condition" : {
          "StringLike" : {
            "aws:sourceArn" : "arn:${local.aws_secondary.partition}:lambda:${local.aws_secondary.region}:${local.aws_secondary.account_id}:function:*"
          }
        }
      }
    ]
  })
}