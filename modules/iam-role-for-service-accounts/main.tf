data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  dns_suffix = data.aws_partition.current.dns_suffix
  region     = data.aws_region.current.name
}

################################################################################
# IAM Role
################################################################################

data "aws_iam_policy_document" "assume" {
  count = var.create ? 1 : 0

  dynamic "statement" {
    for_each = var.enable_irsa_v2 ? [1] : []

    content {
      sid     = "EksAssume"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type = "Service"
        # identifier subject to change
        # identifiers = ["eks-pods.${local.dns_suffix}"]
        identifiers = ["eks.${local.dns_suffix}"]
      }
    }
  }

  dynamic "statement" {
    for_each = var.oidc_providers

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type        = "Federated"
        identifiers = [statement.value.provider_arn]
      }

      condition {
        test     = var.assume_role_condition_test
        variable = "${replace(statement.value.provider_arn, "/^(.*provider/)/", "")}:sub"
        values   = [for sa in statement.value.namespace_service_accounts : "system:serviceaccount:${sa}"]
      }

      # https://aws.amazon.com/premiumsupport/knowledge-center/eks-troubleshoot-oidc-and-irsa/?nc1=h_ls
      condition {
        test     = var.assume_role_condition_test
        variable = "${replace(statement.value.provider_arn, "/^(.*provider/)/", "")}:aud"
        values   = ["sts.amazonaws.com"]
      }

    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name        = var.name
  name_prefix = var.name_prefix
  path        = var.path
  description = var.description

  assume_role_policy    = data.aws_iam_policy_document.assume[0].json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.policies : k => v if var.create }

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

################################################################################
# IAM Policy
################################################################################

locals {
  create_policy = var.create && var.create_policy && (length(var.policy_statements) > 0 || length(local.source_policy_documents) > 0 || length(var.override_policy_documents) > 0)

  source_policy_documents = flatten(concat(
    data.aws_iam_policy_document.cert_manager[*].json,
    data.aws_iam_policy_document.cluster_autoscaler[*].json,
    data.aws_iam_policy_document.ebs_csi[*].json,
    data.aws_iam_policy_document.efs_csi[*].json,
    data.aws_iam_policy_document.external_dns[*].json,
    data.aws_iam_policy_document.external_secrets[*].json,
    data.aws_iam_policy_document.fsx_lustre_csi[*].json,
    data.aws_iam_policy_document.karpenter[*].json,
    data.aws_iam_policy_document.load_balancer_controller[*].json,
    data.aws_iam_policy_document.load_balancer_controller_targetgroup_only[*].json,
    data.aws_iam_policy_document.appmesh_controller[*].json,
    data.aws_iam_policy_document.appmesh_envoy_proxy[*].json,
    data.aws_iam_policy_document.amazon_managed_service_prometheus[*].json,
    data.aws_iam_policy_document.node_termination_handler[*].json,
    data.aws_iam_policy_document.velero[*].json,
    data.aws_iam_policy_document.vpc_cni[*].json,
    data.aws_iam_policy_document.cert_manager[*].json,
    data.aws_iam_policy_document.cert_manager[*].json,
    var.source_policy_documents,
  ))
}

data "aws_iam_policy_document" "this" {
  count = local.create_policy ? 1 : 0

  source_policy_documents   = local.source_policy_documents
  override_policy_documents = var.override_policy_documents

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  count = local.create_policy ? 1 : 0

  name        = try(coalesce(var.policy_name, var.name), null)
  name_prefix = try(coalesce(var.policy_name_prefix, var.name_prefix), null)
  path        = coalesce(var.policy_path, var.path)
  description = try(coalesce(var.policy_description, var.description), null)
  policy      = data.aws_iam_policy_document.this[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.create_policy ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}
