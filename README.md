# AWS Identity and Access Management (IAM) Terraform module

### ⚠️  JUST FOR TESTING - DO NOT RELY ON THIS ⚠️

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

## Features

1. **Cross-account access.** Define IAM roles using `iam_assumable_role` or `iam_assumable_roles` submodules in "resource AWS accounts (prod, staging, dev)" and IAM groups and users using `iam-group-with-assumable-roles-policy` submodule in "IAM AWS Account" to setup access controls between accounts. See [iam-group-with-assumable-roles-policy example](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-group-with-assumable-roles-policy) for more details.
2. **Individual IAM resources (users, roles, policies).** See usage snippets and [examples](https://github.com/terraform-aws-modules/terraform-aws-iam#examples) listed below.

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

`iam-assumable-role`:

```hcl
module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

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

`iam-assumable-role-with-oidc`:

```hcl
module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  name = "example"

  oidc_provider_urls = ["oidc.eks.eu-west-1.amazonaws.com/id/AA9E170D464AF7B92084EF72A69B9DC8"]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:default:sa1",
    "system:serviceaccount:default:sa2",
  ]

  policies = {
    AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

`iam-assumable-role-with-saml`:

```hcl
module "iam_assumable_role_with_saml" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-saml"

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

`iam-assumable-roles-with-saml`:

```hcl
module "iam_assumable_roles_with_saml" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles-with-saml"

  create_admin_role = true

  create_poweruser_role = true
  poweruser_role_name   = "developer"

  create_readonly_role = true

  provider_id   = "arn:aws:iam::235367859851:saml-provider/idp_saml"
}
```

`iam-github-oidc-provider`:

```hcl
module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"

  tags = {
    Environment = "test"
  }
}
```

`iam-github-oidc-role`:

```hcl
module "iam_github_oidc_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"

  # This should be updated to suit your organization, repository, references/branches, etc.
  subjects = ["terraform-aws-modules/terraform-aws-iam:*"]

  policies = {
    S3ReadOnly = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  }

  tags = {
    Environment = "test"
  }
}
```

`iam-group-with-assumable-roles-policy`:

```hcl
module "iam_group_with_assumable_roles_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"

  name = "production-readonly"

  assumable_roles = [
    "arn:aws:iam::835367859855:role/readonly"  # these roles can be created using `iam_assumable_roles` submodule
  ]

  group_users = [
    "user1",
    "user2"
  ]
}
```

`iam-group-with-policies`:

```hcl
module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name = "superadmins"

  group_users = [
    "user1",
    "user2"
  ]

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]

  custom_group_policies = [
    {
      name   = "AllowS3Listing"
      policy = data.aws_iam_policy_document.sample.json
    }
  ]
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

## IAM Best Practices

AWS published [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html) and this Terraform module was created to help with some of points listed there:

1. Create Individual IAM Users

Use the [iam-user module](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-user) module to manage IAM users.

2. Use AWS Defined Policies to Assign Permissions Whenever Possible

Use the [iam-assumable-role module](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-assumable-role) to create IAM roles with managed policies to support common tasks (admin, poweruser or readonly).

3. Use Groups to Assign Permissions to IAM Users

Use [iam-group-with-assumable-roles-policy module](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-group-with-assumable-roles-policy) to manage IAM groups of users who can assume roles.
Use [iam-group-with-policies module](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-group-with-policies) to manage IAM groups of users where specified IAM policies are allowed.

4. Configure a Strong Password Policy for Your Users

Use [iam-account module](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-account) to set password policy for your IAM users.

5. Enable MFA for Privileged Users

Use the [iam-assumable-role module](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-assumable-role) to create IAM roles that require MFA.

6. Delegate by Using Roles Instead of by Sharing Credentials

[iam-assumable-role](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-assumable-role), [iam-assumable-role](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-assumable-role), [iam-assumable-roles-with-saml](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-assumable-roles-with-saml) and [iam-group-with-assumable-roles-policy](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-group-with-assumable-roles-policy) modules provide complete set of functionality required for this.

7. Use Policy Conditions for Extra Security

[iam-assumable-role module](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-assumable-role) can be configured to require valid MFA token when different roles are assumed (for example, admin role requires MFA, but readonly - does not).

8. Create IAM Policies

Use [iam-read-only-policy module](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-read-only-policy) module to manage IAM read-only policies.

## Examples

- [iam-account](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-account) - Set AWS account alias and password policy
- [iam-assumable-role-with-oidc](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-assumable-role-with-oidc) - Create individual IAM role which can be assumed from specified subjects federated with a OIDC Identity Provider
- [iam-assumable-role-with-saml](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-assumable-role-with-saml) - Create individual IAM role which can be assumed by users with a SAML Identity Provider
- [iam-assumable-role](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-assumable-role) - Create individual IAM role which can be assumed from specified ARNs (AWS accounts, IAM users, etc)
- [iam-assumable-roles-with-saml](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-assumable-roles-with-saml) - Create several IAM roles which can be assumed by users with a SAML Identity Provider
- [iam-group-complete](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-group-complete) - IAM group with users who are allowed to assume IAM roles in another AWS account and have access to specified IAM policies
- [iam-group-with-assumable-roles-policy](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-group-with-assumable-roles-policy) - IAM group with users who are allowed to assume IAM roles in the same or in separate AWS account
- [iam-group-with-policies](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-group-with-policies) - IAM group with users who are allowed specified IAM policies (eg, "manage their own IAM user")
- [iam-read-only-policy](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-read-only-policy) - Create IAM read-only policy
- [iam-role-for-service-accounts-eks](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-role-for-service-accounts-eks) - Create IAM role for service accounts (IRSA) for use within EKS clusters
- [iam-user](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-user) - Add IAM user, login profile and access keys (with PGP enabled or disabled)

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-iam/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/LICENSE) for full details.

## Additional information for users from Russia and Belarus

* Russia has [illegally annexed Crimea in 2014](https://en.wikipedia.org/wiki/Annexation_of_Crimea_by_the_Russian_Federation) and [brought the war in Donbas](https://en.wikipedia.org/wiki/War_in_Donbas) followed by [full-scale invasion of Ukraine in 2022](https://en.wikipedia.org/wiki/2022_Russian_invasion_of_Ukraine).
* Russia has brought sorrow and devastations to millions of Ukrainians, killed hundreds of innocent people, damaged thousands of buildings, and forced several million people to flee.
* [Putin khuylo!](https://en.wikipedia.org/wiki/Putin_khuylo!)
