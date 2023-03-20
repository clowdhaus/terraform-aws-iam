# IAM group with assumable roles policy example

Configuration in this directory creates IAM group with users who are allowed to assume IAM roles.

# Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_aws.production"></a> [aws.production](#provider\_aws.production) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_custom"></a> [iam\_assumable\_role\_custom](#module\_iam\_assumable\_role\_custom) | ../../modules/iam-assumable-role | n/a |
| <a name="module_iam_group_with_assumable_roles_policy_production_custom"></a> [iam\_group\_with\_assumable\_roles\_policy\_production\_custom](#module\_iam\_group\_with\_assumable\_roles\_policy\_production\_custom) | ../../modules/iam-group-with-assumable-roles-policy | n/a |
| <a name="module_iam_user1"></a> [iam\_user1](#module\_iam\_user1) | ../../modules/iam-user | n/a |
| <a name="module_iam_user2"></a> [iam\_user2](#module\_iam\_user2) | ../../modules/iam-user | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.iam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.production](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_account_id"></a> [iam\_account\_id](#output\_iam\_account\_id) | IAM AWS account id (this code is managing resources in this account) |
| <a name="output_production_account_id"></a> [production\_account\_id](#output\_production\_account\_id) | Production AWS account id |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
