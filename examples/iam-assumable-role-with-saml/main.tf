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
# IAM Assumable Role w/ SAML
################################################################################

module "iam_assumable_role" {
  source = "../../modules/iam-assumable-role-with-saml"

  name = local.name

  saml_provider_ids = [aws_iam_saml_provider.this.id]

  policies = {
    ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }

  tags = local.tags
}

module "iam_assumable_role_disabled" {
  source = "../../modules/iam-assumable-role-with-oidc"

  create = false
}

################################################################################
# Supporting Resources
################################################################################

resource "aws_iam_saml_provider" "this" {
  name                   = "idp_saml"
  saml_metadata_document = file("saml-metadata.xml")
}
