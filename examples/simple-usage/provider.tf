terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

locals {
  default_tags = {
    ManagedBy       = "Terraform"
    Environment     = "Production"
    BusinessUnit    = "Core Engineering"
    SpendAllocation = "Infrastructure"
    Owner           = "SRE"
    GitHub          = "https://github.com/glg/spacelift/issues/647"
  }
}

provider "aws" {
  max_retries = 2
  region      = "invalid"
  access_key  = "invalid"
  secret_key  = "invalid"
  token       = "invalid"
}

provider "aws" {
  alias               = "prototype_use1"
  max_retries         = 2 # default is 25
  region              = "us-east-1"
  allowed_account_ids = ["988857891049"] # prototype

  default_tags { tags = local.default_tags }

  assume_role {
    role_arn = "arn:aws:iam::988857891049:role/infrastructure-as-code-write"
  }
}

provider "aws" {
  alias               = "experiments_use1"
  max_retries         = 2 # default is 25
  region              = "us-east-1"
  allowed_account_ids = ["474668255207"] # prototype

  default_tags { tags = local.default_tags }

  assume_role {
    role_arn = "arn:aws:iam::474668255207:role/infrastructure-as-code-write"
  }
}

