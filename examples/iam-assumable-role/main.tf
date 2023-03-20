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
# IAM Assumable Role - Instance Profile
################################################################################

module "iam_assumable_role_instance_profile" {
  source = "../../modules/iam-assumable-role"

  name = "${local.name}-instance-profile"

  # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
  allow_self_assume_role  = true
  create_instance_profile = true

  assume_role_policy_statements = [
    {
      sid = "TrustRoleAndServiceToAssume"
      principals = [
        {
          type = "AWS"
          identifiers = [
            "arn:aws:iam::307990089504:root",
            "arn:aws:iam::835367859851:user/anton",
          ]
        },
        {
          type = "Service"
          identifiers = [
            "codedeploy.amazonaws.com",
          ]
        }
      ]
    }
  ]

  policies = {
    ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }

  tags = local.tags
}

################################################################################
# IAM Assumable Role - Conditions
################################################################################

module "iam_assumable_role_conditions" {
  source = "../../modules/iam-assumable-role"

  name_prefix = "conditions-"

  assume_role_policy_statements = [
    {
      sid = "TrustRoleAndServiceToAssume"
      principals = [{
        type = "AWS"
        identifiers = [
          "arn:aws:iam::835367859851:user/anton",
        ]
      }]
      conditions = [{
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = ["some-secret-id"]
      }]
    }
  ]

  policies = {
    AmazonCognitoReadOnly      = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
    AlexaForBusinessFullAccess = "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess"
    custom                     = module.iam_policy.arn
  }

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

module "iam_policy" {
  source = "../../modules/iam-policy"

  name        = local.name
  path        = "/"
  description = "Example policy"

  policy = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "ec2:Describe*"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }
  EOT

  tags = local.tags
}
