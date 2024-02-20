#############################################################################
# Data Resource
##############################################################################
data "aws_partition" "primary" {
  provider = aws.prototype_use1
}

data "aws_region" "current" {
  provider = aws.prototype_use1
}
data "aws_caller_identity" "current" {
  provider = aws.prototype_use1
}

resource "random_string" "sample" {
  special = false
  upper   = false
  length  = 4
}

locals {
  id          = random_string.sample.id
  secret_name = "dev/spacelift-sumo/apiKeys"
}

module "target" {
  source = "../../"
  providers = {
    aws.primary   = aws.prototype_use1,
    aws.secondary = aws.experiments_use1,
  }
  name            = "test-${local.id}"
  github_monorepo = "glg/infrastructure-support-lambdas"
  custom_policy = {
    LambdaAdditionalPolicy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue"
        ]
        "Resource" : [
          "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.secret_name}-??????"
        ]
      }
    })
  }
}

output "all" {
  value = module.target
}
