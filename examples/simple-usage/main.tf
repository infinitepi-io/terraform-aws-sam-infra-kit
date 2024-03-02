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
## Prototype Development.
module "target" {
  source = "../../"
  providers = {
    aws.lambda_role    = aws.prototype_use1,
    aws.ecr_repository = aws.prototype_use1,
  }
  name            = "test-access"
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
## Deploying the cross account lambda. lambda in infra-mgnt and ECR repo in experiments_use1.
module "target2" {
  source = "../../"
  providers = {
    aws.lambda_role    = aws.experiments_use1,
    aws.ecr_repository = aws.infra_mgnt_use1,
  }
  name            = "test-access"
  github_monorepo = "glg/infrastructure-support-lambdas"
  # All the cross account access will be controlled from here. This shows how many account lambda is currently deployed.
  account_ids = [
    "474668255207",
    #Add the below account to allow access to ECR if the same image is used for other account. like in target3
    "196017527820"
  ]
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
# The same lambda is deployed in the same account as ECR repository. 
module "target3" {
  source = "../../"
  providers = {
    aws.lambda_role    = aws.infra_mgnt_use1,
    aws.ecr_repository = aws.infra_mgnt_use1,
  }
  name            = "test-access"
  github_monorepo = "glg/infrastructure-support-lambdas"
  ecr_creation    = false
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
  value = {
    target  = module.target,
    target2 = module.target2
    target3 = module.target3
  }
}
