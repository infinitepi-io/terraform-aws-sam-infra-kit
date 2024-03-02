resource "aws_ecr_repository" "this" {
  provider             = aws.ecr_repository
  count                = var.ecr_creation ? 1 : 0
  name                 = "${var.github_monorepo}/${var.name}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository_policy" "this" {
  provider   = aws.ecr_repository
  count      = var.ecr_creation ? 1 : 0
  repository = aws_ecr_repository.this[0].name
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "LambdaECRImageRetrievalPolicy",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:DeleteRepositoryPolicy",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:PrincipalOrgID" : "o-ifre3ueanm"
          }
        }
      },
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
        ],
        "Condition" : {
          "StringLike" : {
            "aws:SourceArn" : local.allowed_function_arns
          }
        }
      },
      {
        "Sid" : "DenyAccessToEcrRepository",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "ecr:*"
        "Condition" : {
          "StringNotLike" : {
            "aws:SourceArn" : local.denied_function_arns
          }
        }
      }
    ]
  })
}
