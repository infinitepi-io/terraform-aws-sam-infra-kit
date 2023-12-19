resource "random_string" "sample" {
  special = false
  upper   = false
  length  = 4
}

locals {
  id = random_string.sample.id
  tags = {
    # https://github.com/glg/sre/wiki/Tagging-Resources
    # Use any tags that are applicable and not already covered by default_tags
    BusinessUnit    = "Core Engineering"
    SpendAllocation = "Infrastructure"
    Owner           = "SRE"
    App             = "Sample"
    ZenDesk         = "https://glghd.zendesk.com/agent/tickets/xxxx"        # Optional
    GitHub          = "https://github.com/glg/metadevops-issues/issues/xxx" # Optional
    FollowUp        = "1970-01-01"                                          # Optional
    FollowUpReason  = "https://github.com/glg/metadevops-issues/issues/xxx" # Optional
  }
}

module "target" {
  source = "../../"

  # - This is an example as to how you would work with multiple providers in a module
  # - If only one provider is needed, just remove the secondary.
  # - Also, providers don't have to be named primary or secondary, any name that makes
  #   sense works here.
  providers = {
    aws.primary = aws.prototype_use1
  }

  # Example variables, don't need to be used
  name = "test-${local.id}"
  tags = merge(local.tags, {
    "Hello" = "World"
  })
}

output "all" {
  value = module.target
}
