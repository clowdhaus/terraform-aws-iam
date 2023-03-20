# Individual IAM assumable roles example

Configuration in this directory creates several individual IAM roles which can be assumed from a defined list of [IAM ARNs](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-arns).

The main difference between `iam-assumable-role` and `iam-assumable-roles` examples is that the former creates just a single role.

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

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_conditions"></a> [iam\_assumable\_role\_conditions](#module\_iam\_assumable\_role\_conditions) | ../../modules/iam-assumable-role | n/a |
| <a name="module_iam_assumable_role_instance_profile"></a> [iam\_assumable\_role\_instance\_profile](#module\_iam\_assumable\_role\_instance\_profile) | ../../modules/iam-assumable-role | n/a |
| <a name="module_iam_policy"></a> [iam\_policy](#module\_iam\_policy) | ../../modules/iam-policy | n/a |

## Resources

No resources.

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
