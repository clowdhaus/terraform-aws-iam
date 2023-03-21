# AWS Identity and Access Management (IAM) Terraform module

### ⚠️  JUST FOR TESTING - DO NOT RELY ON THIS ⚠️

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

Please refer to the AWS published [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html) for up to date guidance on IAM best practices.

## Usage

`iam-account`:

```hcl
module "iam_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-account"

  account_alias = "awesome-company"

  minimum_password_length = 37
  require_numbers         = false
}
```

`iam-role`:

```hcl
module "iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "example"

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
    custom                     = aws_iam_policy.this.arn
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

`iam-role-oidc`:

```hcl
module "iam_oidc_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-oidc-role"

  enable_github_oidc = true

  # This should be updated to suit your organization, repository, references/branches, etc.
  oidc_subjects = ["terraform-aws-modules/terraform-aws-iam:*"]

  policies = {
    S3ReadOnly = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

`iam-role-saml`:

```hcl
module "iam_role_saml" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-saml"

  name = "example"

  saml_provider_ids = ["arn:aws:iam::235367859851:saml-provider/idp_saml"]

  policies = {
    ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

`iam-oidc-provider`:

```hcl
module "iam_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"

  url = "https://token.actions.githubusercontent.com"

  tags = {
    Environment = "test"
  }
}
```

`iam-group`:

```hcl
module "iam_group" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group"

  name = "superadmins"

  users = [
    "user1",
    "user2"
  ]

  enable_self_management_permissions = true
  permission_statements = [
    {
      sid       = "AssumeRole"
      actions   = ["sts:AssumeRole"]
      resources = ["arn:aws:iam::111111111111:role/admin"]
    }
  ]

  policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess",
  }
}
```

`iam-read-only-policy`:

```hcl
module "iam_read_only_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-read-only-policy"

  name        = "example"
  path        = "/"
  description = "My example read-only policy"

  allowed_services = ["rds", "dynamo", "health"]
}
```

`iam-role-for-service-accounts-eks`:

```hcl
module "vpc_cni_irsa" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name   = "vpc-cni"

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = "arn:aws:iam::012345678901:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/5C54DDF35ER19312844C7333374CC09D"
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = {
    Name = "vpc-cni-irsa"
  }
}
```

`iam-user`:

```hcl
module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = "vasya.pupkin"
  force_destroy = true

  pgp_key = "keybase:test"

  password_reset_required = false
}
```

## Examples

- [iam-account](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-account) - Set AWS account alias and password policy
- [iam-group](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-group) - IAM group with users who are allowed to assume IAM roles in another AWS account and have access to specified IAM policies
- [iam-oidc-provider](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-oidc-provider) - Create an OpenID connect provider and IAM role which can be assumed from specified subjects federated from the OIDC provider
- [iam-read-only-policy](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-read-only-policy) - Create IAM read-only policy
- [iam-role](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-role) - Create individual IAM role which can be assumed from specified ARNs (AWS accounts, IAM users, etc)
- [iam-role-for-service-accounts-eks](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-role-for-service-accounts-eks) - Create IAM role for service accounts (IRSA) for use within EKS clusters
- [iam-role-saml](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-role-saml) - Create individual IAM role which can be assumed by users with a SAML Identity Provider
- [iam-user](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-user) - Add IAM user, login profile and access keys (with PGP enabled or disabled)

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-iam/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/LICENSE) for full details.

## Additional information for users from Russia and Belarus

* Russia has [illegally annexed Crimea in 2014](https://en.wikipedia.org/wiki/Annexation_of_Crimea_by_the_Russian_Federation) and [brought the war in Donbas](https://en.wikipedia.org/wiki/War_in_Donbas) followed by [full-scale invasion of Ukraine in 2022](https://en.wikipedia.org/wiki/2022_Russian_invasion_of_Ukraine).
* Russia has brought sorrow and devastations to millions of Ukrainians, killed hundreds of innocent people, damaged thousands of buildings, and forced several million people to flee.
* [Putin khuylo!](https://en.wikipedia.org/wiki/Putin_khuylo!)
