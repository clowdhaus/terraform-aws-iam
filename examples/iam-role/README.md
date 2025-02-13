# AWS IAM Role Example

Configuration in this directory creates IAM roles with different options for permissions and role assumption.

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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_role_conditions"></a> [iam\_role\_conditions](#module\_iam\_role\_conditions) | ../../modules/iam-role | n/a |
| <a name="module_iam_role_disabled"></a> [iam\_role\_disabled](#module\_iam\_role\_disabled) | ../../modules/iam-role | n/a |
| <a name="module_iam_role_instance_profile"></a> [iam\_role\_instance\_profile](#module\_iam\_role\_instance\_profile) | ../../modules/iam-role | n/a |
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../../modules/iam-role | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_conditions_iam_instance_profile_arn"></a> [conditions\_iam\_instance\_profile\_arn](#output\_conditions\_iam\_instance\_profile\_arn) | ARN assigned by AWS to the instance profile |
| <a name="output_conditions_iam_instance_profile_id"></a> [conditions\_iam\_instance\_profile\_id](#output\_conditions\_iam\_instance\_profile\_id) | Instance profile's ID |
| <a name="output_conditions_iam_instance_profile_name"></a> [conditions\_iam\_instance\_profile\_name](#output\_conditions\_iam\_instance\_profile\_name) | Name of IAM instance profile |
| <a name="output_conditions_iam_instance_profile_unique_id"></a> [conditions\_iam\_instance\_profile\_unique\_id](#output\_conditions\_iam\_instance\_profile\_unique\_id) | Stable and unique string identifying the IAM instance profile |
| <a name="output_conditions_iam_role_arn"></a> [conditions\_iam\_role\_arn](#output\_conditions\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the IAM role |
| <a name="output_conditions_iam_role_name"></a> [conditions\_iam\_role\_name](#output\_conditions\_iam\_role\_name) | The name of the IAM role |
| <a name="output_conditions_iam_role_unique_id"></a> [conditions\_iam\_role\_unique\_id](#output\_conditions\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
| <a name="output_instance_profile_iam_instance_profile_arn"></a> [instance\_profile\_iam\_instance\_profile\_arn](#output\_instance\_profile\_iam\_instance\_profile\_arn) | ARN assigned by AWS to the instance profile |
| <a name="output_instance_profile_iam_instance_profile_id"></a> [instance\_profile\_iam\_instance\_profile\_id](#output\_instance\_profile\_iam\_instance\_profile\_id) | Instance profile's ID |
| <a name="output_instance_profile_iam_instance_profile_name"></a> [instance\_profile\_iam\_instance\_profile\_name](#output\_instance\_profile\_iam\_instance\_profile\_name) | Name of IAM instance profile |
| <a name="output_instance_profile_iam_instance_profile_unique_id"></a> [instance\_profile\_iam\_instance\_profile\_unique\_id](#output\_instance\_profile\_iam\_instance\_profile\_unique\_id) | Stable and unique string identifying the IAM instance profile |
| <a name="output_instance_profile_iam_role_arn"></a> [instance\_profile\_iam\_role\_arn](#output\_instance\_profile\_iam\_role\_arn) | The Amazon Resource Name (ARN) specifying the IAM role |
| <a name="output_instance_profile_iam_role_name"></a> [instance\_profile\_iam\_role\_name](#output\_instance\_profile\_iam\_role\_name) | The name of the IAM role |
| <a name="output_instance_profile_iam_role_unique_id"></a> [instance\_profile\_iam\_role\_unique\_id](#output\_instance\_profile\_iam\_role\_unique\_id) | Stable and unique string identifying the IAM role |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
