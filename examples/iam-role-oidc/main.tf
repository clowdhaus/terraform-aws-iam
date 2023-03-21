provider "aws" {
  region = "eu-west-1"
}

locals {
  name = "ex-${basename(path.cwd)}"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-iam"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# IAM Role w/ OIDC
################################################################################

module "iam_role" {
  source = "../../modules/iam-role-oidc"

  name = local.name

  oidc_provider_urls = ["oidc.eks.eu-west-1.amazonaws.com/id/AA9E170D464AF7B92084EF72A69B9DC8"]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:default:sa1",
    "system:serviceaccount:default:sa2",
  ]

  policies = {
    AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }

  tags = local.tags
}

module "iam_role_disabled" {
  source = "../../modules/iam-role-oidc"

  create = false
}
