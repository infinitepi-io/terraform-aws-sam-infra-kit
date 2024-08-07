[![unit-test](../../../actions/workflows/unit-test.yml/badge.svg)](../../../actions/workflows/unit-test.yml)

# `terraform-aws-sam-infra-kit`

This module creates lambda function role and ECR repository for SAM lambda deployed using **[infrastructure-management-lambda]([https://github.com/glg/infrastructure-management-lambda](https://github.com/infinitepi-io/infrastructure-support-lambdas))** .

## Usage

Name of the roles and repository will be given by the script while onboarding the lambda function to **[infrastructure-management-lambda](https://github.com/glg/infrastructure-management-lambda)**
repository.
**Example:**

```bash
# Prototype deployment: lambda role and ECR repository will be created in prototype account. 
module "target1" {
  source = "git@github.com:infinitepi-io/terraform-aws-sam-infra-kit.git?ref=v1.0.0"
  providers = {
    aws.lambda_role    = aws.prototype_use1,
    aws.ecr_repository = aws.prototype_use1
  }
  name            = "${project_name}"
  github_monorepo = "${mono_repo_name}"
  ecr_creation = true
  custom_policy = {
    # ${policy_name} = ${josn_policy}
    LambdaAdditionalPolicy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : {
        "Effect" : "...",
        "Action" : [
          "..."
        ]
        "Resource" : [
          "..."
        ]
      }
    })
  }
}
# For all the lambdas deployed outside the prototype account or for production deployments, we will create a repository in the infrastructure-management account and roles in the respective accounts. In the below example lambda is deployed in account-1 and account-1.
module "target2" {
  source = "git@github.com:infinitepi-io/terraform-aws-sam-infra-kit.git?ref=v1.0.0"
  providers = {
    aws.lambda_role    = aws.${account-1},
    aws.ecr_repository = aws.infrastructure-management_use1,
  }
  name            = "${project_name}"
  github_monorepo = "glg/infrastructure-support-lambdas"
  ecr_creation = true
  account_ids = [
    "${account-1_id}",
    "${account-2_id}",
  ]
   custom_policy = {
    # ${policy_name} = ${josn_policy}
    LambdaAdditionalPolicy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : {
        "Effect" : "...",
        "Action" : [
          "..."
        ]
        "Resource" : [
          "..."
        ]
      }
    })
  }
}
# Creating lambda role in account-2.
module "target3" {
  source = "git@github.com:infinitepi-io/terraform-aws-sam-infra-kit.git?ref=v1.0.0"
  providers = {
    aws.lambda_role    = aws.${account-2},
    aws.ecr_repository = aws.infrastructure-management_use1,
  }
  name            = "${project_name}"
  github_monorepo = "glg/infrastructure-support-lambdas"
   custom_policy = {
    # ${policy_name} = ${josn_policy}
    LambdaAdditionalPolicy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : {
        "Effect" : "...",
        "Action" : [
          "..."
        ]
        "Resource" : [
          "..."
        ]
      }
    })
  }
}

output "all" {
  value = {
    target1  = module.target1,
    target2 = module.target2,
    target3 = module.target3
  }
```

## Testing Overview

To better understand some of the terminology, I highly recommend at least reading over [this blog post](https://www.hashicorp.com/blog/testing-hashicorp-terraform) explaining some of the basic terraform test concepts, such as what a **unit test** is.

Our current system is focused on the following.

- Local **Unit Tests**

  These use the *currently installed version* of Terraform, and do a basic sanity on the module to make sure it would run at all.
- Automated **Unit Tests** via GitHub actions.

  These are fired automatically on commit to GitHub, but can also be executed locally.  They run against a matrix of Terraform versions to make establish that versions of Terraform this module could support.
- Locally initiated **Integration Tests**.

## 1. Local Unit Tests

- Uses locally installed `terraform` to validate `.tf` files.
- DOES NOT create any resources

### Requirements

- Terraform

### Steps

```bash
make unit-test
```

## 2. Local Automated Unit Tests

- Run the Unit Tests via the GitHub action locally.

### Requirements

- Terraform
- [nektos/act](https://github.com/nektos/act)

### Steps

```bash
# a module with only public or no dependencies on other modules
make action

# if you need to test a module with private dependencies
export TF_TESTABLE_MODULE_SSH_KEY=$(</path/to/ssh/key/with/github/access)
make action
```

## 3. Locally Initiated Integration Tests

### Full Test

The test is a basic `terraform init/apply/destroy` using local state.

```bash
# provide environment variables for the AWS provider
# , then run...
make full-test
```

### Partial Test

When iterating on code, it can sometimes be useful not to destroy.  In that case, just call the individual operations.

```bash
# if you want to just run a plan
make plan
# create/update the resources
make apply
# do more dev
make apply
# ... (repeat until done)

# destroy only
make destroy
```

<!-- BEGIN_TF_DOCS --

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| aws       | >= 5.0  |

## Providers

| Name                | Version |
| ------------------- | ------- |
| aws.ecr\_repository | >= 5.0  |
| aws.lambda\_role    | >= 5.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                         | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)                           | resource    |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy)             | resource    |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                       | resource    |
| [aws_iam_role_policy_attachment.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_caller_identity.ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)            | data source |
| [aws_caller_identity.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)               | data source |
| [aws_partition.ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                        | data source |
| [aws_partition.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition)                           | data source |
| [aws_region.ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                              | data source |
| [aws_region.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                 | data source |

## Inputs

| Name             | Description                                                                                       | Type             | Default                                               | Required |
| ---------------- | ------------------------------------------------------------------------------------------------- | ---------------- | ----------------------------------------------------- | :------: |
| account\_ids     | A list of accounts to give access to multiple account lambda deployment using the same ecr image. | `list(string)` | `<pre>`[`<br>`  "988857891049"`<br>`]`</pre>` |    no    |
| custom\_policy   | Additional policy required to for the lambda function.                                            | `map(string)`  | `{}`                                                |    no    |
| ecr\_creation    | Use this flag to create ecr repository and policy.                                                | `bool`         | `false`                                             |    no    |
| github\_monorepo | GitHub repository name                                                                            | `string`       | n/a                                                   |   yes   |
| name             | 'name' will at least in part be assigned to most resources                                        | `string`       | n/a                                                   |   yes   |

## Outputs

| Name            | Description |
| --------------- | ----------- |
| ecr\_repository | n/a         |
| lambda\_role    | n/a         |

<!-- END_TF_DOCS -->
