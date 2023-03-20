# Upgrade from v5.x to v6.x

If you have any questions regarding this upgrade process, please consult the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/) directory:

If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- `iam-assumable-roles` has been removed; `iam-assumable-role` should be used instead. See the [`iam-assumable-role` example](https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/examples/iam-assumable-role) that shows an example replacement implementation.
- `iam-eks-role` has been removed; `iam-role-for-service-accounts-eks` should be used instead
- `iam-policy` has been removed; the `aws_iam_policy` resource should be used directly instead

## Additional changes

### Modified

- `iam-assumable-role`
    - The use of individual variables to control/manipulate the assume role trust policy have been replaced by a generic `assume_role_policy_statements` variable. This allows for any number of custom statements to be added to the role's trust policy.
    - `custom_role_policy_arns` has been renmaed to `policies` and now accepts a map of `name`: `policy-arn` pairs; this allows for both existing policies and policies that will get created at the same time as the role. This also replaces the admin, readonly, and poweruser policy ARN variables and their associated `attach_*_policy` variables.
    - Default create conditional is now `true` instead of `false`
    - `force_detach_policies` has been removed; this is now always `true`

### Variable and output changes

1. Removed variables:

    - `iam-assumable-role`
        - `trusted_role_actions`
        - `trusted_role_arns`
        - `trusted_role_services`
        - `mfa_age`
        - `role_requires_mfa`
        - `custom_role_trust_policy`
        - `number_of_custom_role_policy_arns`
        - `admin_role_policy_arn` & `attach_admin_policy`
        - `poweruser_role_policy_arn` & `attach_poweruser_policy`
        - `readonly_role_policy_arn` & `attach_readonly_policy`
        - `force_detach_policies`
        - `role_sts_externalid`

2. Renamed variables:

    - `iam-assumable-role`
        - `create_role` -> `create`
        - `role_name` -> `name`
        - `role_name_prefix` -> `name_prefix`
        - `role_description` -> `description`
        - `role_path` -> `path`
        - `role_permissions_boundary_arn` -> `permissions_boundary_arn`
        - `custom_role_policy_arns` -> `policies`

3. Added variables:

    - `iam-assumable-role`
        - `assume_role_policy_statements` which allows for any number of custom statements to be added to the role's trust policy. This covers the majority of the variables that were removed.

4. Removed outputs:

    - `iam-assumable-role`
        - `iam_role_path`
        - `role_requires_mfa`
        - `iam_instance_profile_path`
        - `role_sts_externalid`

5. Renamed outputs:

    - `iam-assumable-role`
        - `iam_role_arn` -> `arn`
        - `iam_role_name` -> `name`
        - `iam_role_unique_id` -> `unique_id`
        - `iam_instance_profile_arn` -> `instance_profile_arn`
        - `iam_instance_profile_id` -> `instance_profile_id`
        - `iam_instance_profile_name` -> `instance_profile_name`
        - `iam_instance_profile_unique_id` -> `instance_profile_unique_id`

6. Added outputs:

    -

### Diff of before <> after

#### `iam-assumable-role`

```diff
module "iam_assumable_role" {
   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
-  version = "~> 5.0"
+  version = "~> 6.0"

-  create_role = true
+  create = true # is now `true` by default

-  role_requires_mfa = true
-  trusted_role_arns = [
-    "arn:aws:iam::307990089504:root",
-    "arn:aws:iam::835367859851:user/anton",
-  ]
-  trusted_role_services = [
-    "codedeploy.amazonaws.com"
-  ]
-  role_sts_externalid = ["some-id-goes-here"]
+  assume_role_policy_statements = [
+    {
+      sid = "TrustRoleAndServiceToAssume"
+      principals = [
+        {
+          type = "AWS"
+          identifiers = [
+            "arn:aws:iam::307990089504:root",
+            "arn:aws:iam::835367859851:user/anton",
+          ]
+        },
+        {
+          type = "Service"
+          identifiers = ["codedeploy.amazonaws.com"]
+        }
+      ]
+      conditions = [{
+        test     = "StringEquals"
+        variable = "sts:ExternalId"
+        values   = ["some-secret-id"]
+      }]
+    }
+  ]

-  attach_admin_policy = true
-  custom_role_policy_arns = [
-    "arn:aws:iam::aws:policy/AmazonCognitoReadOnly",
-    "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess",
-    module.iam_policy.arn
-  ]
+  policies = {
+    AdministratorAccess        = "arn:aws:iam::aws:policy/AdministratorAccess"
+    AmazonCognitoReadOnly      = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
+    AlexaForBusinessFullAccess = "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess"
+    custom                     = module.iam_policy.arn
+  }
}

### State Changes

None
