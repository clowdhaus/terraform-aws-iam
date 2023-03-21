provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region = "eu-west-1"

  assume_role {
    role_arn = "arn:aws:iam::835367859851:role/anton-demo"
  }

  alias = "production"
}

data "aws_caller_identity" "iam" {}

data "aws_caller_identity" "production" {
  provider = aws.production
}

############
# IAM users
############
module "iam_user1" {
  source = "../../modules/iam-user"

  name = "user1"

  create_iam_user_login_profile = false
  create_iam_access_key         = false
}

module "iam_user2" {
  source = "../../modules/iam-user"

  name = "user2"

  create_iam_user_login_profile = false
  create_iam_access_key         = false
}

#####################################################################################
# Several IAM roles (admin, poweruser, readonly) in production AWS account
# Note: Anyone from IAM account can assume them.
#####################################################################################

module "iam_role" {
  source = "../../modules/iam-role"

  providers = {
    aws = aws.production
  }

  name = "custom"

  assume_role_policy_statements = [
    {
      sid = "TrustRoleAndServiceToAssume"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.iam.account_id}:root"]
      }]
      conditions = [
        {
          test     = "Bool"
          variable = "aws:MultiFactorAuthPresent"
          values   = ["true"]
        },
        {
          test     = "NumericLessThan"
          variable = "aws:MultiFactorAuthAge"
          values   = [86400]
        }
      ]
    }
  ]

  policies = {
    AmazonCognitoReadOnly      = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
    AlexaForBusinessFullAccess = "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess"
  }
}

################################################################################################
# IAM group where user2 is allowed to assume custom role in production AWS account
# Note: IAM AWS account is default, so there is no need to specify it here.
################################################################################################
module "iam_group_with_assumable_roles_policy_production_custom" {
  source = "../../modules/iam-group-with-assumable-roles-policy"

  name = "production-custom"

  assumable_roles = [module.iam_role.arn]

  group_users = [
    module.iam_user2.iam_user_name,
  ]
}
