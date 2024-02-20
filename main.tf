data "aws_region" "primary" {
  provider = aws.primary
}
data "aws_caller_identity" "primary" {
  provider = aws.primary
}
data "aws_partition" "primary" {
  provider = aws.primary
}
data "aws_region" "secondary" {
  provider = aws.secondary
}
data "aws_caller_identity" "secondary" {
  provider = aws.secondary
}
data "aws_partition" "secondary" {
  provider = aws.secondary
}
locals {
  aws_primary = {
    region     = data.aws_region.primary.name
    account_id = data.aws_caller_identity.primary.account_id
    dns_suffix = data.aws_partition.primary.dns_suffix
    partition  = data.aws_partition.primary.partition
  }
  aws_secondary = {
    region     = data.aws_region.secondary.name
    account_id = data.aws_caller_identity.secondary.account_id
    dns_suffix = data.aws_partition.secondary.dns_suffix
    partition  = data.aws_partition.secondary.partition
  }
}
