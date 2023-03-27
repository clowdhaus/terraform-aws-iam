variable "create" {
  description = "Controls if resources should be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# IAM Role
################################################################################

variable "name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Name prefix to use on IAM role created"
  type        = string
  default     = null
}

variable "path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours"
  type        = number
  default     = null
}

variable "permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "assume_role_condition_test" {
  description = "Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate when assuming the role"
  type        = string
  default     = "StringEquals"
}

variable "oidc_providers" {
  description = "Map of OIDC providers where each provider map should contain the `provider`, `provider_arn`, and `namespace_service_accounts`"
  type        = any
  default     = {}
}

variable "enable_irsa_v2" {
  description = "Determines whether to add the new IRSAv2 IAM assume role trust policy"
  type        = bool
  default     = false
}

variable "policies" {
  description = "Policies to attach to the IAM role in `{'static_name' = 'policy_arn'}` format"
  type        = map(string)
  default     = {}
}

################################################################################
# IAM Policy
################################################################################

variable "create_policy" {
  description = "Whether to create an IAM policy that is attached to the IAM role created"
  type        = bool
  default     = true
}

variable "source_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s"
  type        = list(string)
  default     = []
}

variable "override_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`"
  type        = list(string)
  default     = []
}

variable "policy_statements" {
  description = "List of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement)"
  type        = any
  default     = []
}

variable "policy_name" {
  description = "Name to use on IAM policy created"
  type        = string
  default     = null
}

variable "policy_name_prefix" {
  description = "Name prefix to use on IAM policy created"
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Path of IAM policy"
  type        = string
  default     = null
}

variable "policy_description" {
  description = "IAM policy description"
  type        = string
  default     = null
}

# Cert Manager
variable "attach_cert_manager_policy" {
  description = "Determines whether to attach the Cert Manager IAM policy to the role"
  type        = bool
  default     = false
}

variable "cert_manager_hosted_zone_arns" {
  description = "Route53 hosted zone ARNs to allow Cert manager to manage records"
  type        = list(string)
  default     = ["arn:aws:route53:::hostedzone/*"]
}

# Cluster autoscaler
variable "attach_cluster_autoscaler_policy" {
  description = "Determines whether to attach the Cluster Autoscaler IAM policy to the role"
  type        = bool
  default     = false
}

variable "cluster_autoscaler_cluster_names" {
  description = "List of cluster names to appropriately scope permissions within the Cluster Autoscaler IAM policy"
  type        = list(string)
  default     = []
}

# EBS CSI
variable "attach_ebs_csi_policy" {
  description = "Determines whether to attach the EBS CSI IAM policy to the role"
  type        = bool
  default     = false
}

variable "ebs_csi_kms_cmk_ids" {
  description = "KMS CMK IDs to allow EBS CSI to manage encrypted volumes"
  type        = list(string)
  default     = []
}

# EFS CSI
variable "attach_efs_csi_policy" {
  description = "Determines whether to attach the EFS CSI IAM policy to the role"
  type        = bool
  default     = false
}

# External DNS
variable "attach_external_dns_policy" {
  description = "Determines whether to attach the External DNS IAM policy to the role"
  type        = bool
  default     = false
}

variable "external_dns_hosted_zone_arns" {
  description = "Route53 hosted zone ARNs to allow External DNS to manage records"
  type        = list(string)
  default     = ["arn:aws:route53:::hostedzone/*"]
}

# External Secrets
variable "attach_external_secrets_policy" {
  description = "Determines whether to attach the External Secrets policy to the role"
  type        = bool
  default     = false
}

variable "external_secrets_ssm_parameter_arns" {
  description = "List of Systems Manager Parameter ARNs that contain secrets to mount using External Secrets"
  type        = list(string)
  default     = ["arn:aws:ssm:*:*:parameter/*"]
}

variable "external_secrets_secrets_manager_arns" {
  description = "List of Secrets Manager ARNs that contain secrets to mount using External Secrets"
  type        = list(string)
  default     = ["arn:aws:secretsmanager:*:*:secret:*"]
}

# FSx Lustre CSI
variable "attach_fsx_lustre_csi_policy" {
  description = "Determines whether to attach the FSx for Lustre CSI Driver IAM policy to the role"
  type        = bool
  default     = false
}

variable "fsx_lustre_csi_service_role_arns" {
  description = "Service role ARNs to allow FSx for Lustre CSI create and manage FSX for Lustre service linked roles"
  type        = list(string)
  default     = ["arn:aws:iam::*:role/aws-service-role/s3.data-source.lustre.fsx.amazonaws.com/*"]
}

# Karpenter
variable "attach_karpenter_policy" {
  description = "Determines whether to attach the Karpenter policy to the role"
  type        = bool
  default     = false
}

variable "karpenter_cluster_name" {
  description = "Name of cluster where the Karpenter is provisioned"
  type        = string
  default     = "*"
}

variable "karpenter_tag_key" {
  description = "Tag key (`{key = value}`) applied to resources launched by Karpenter through the Karpenter provisioner"
  type        = string
  default     = "karpenter.sh/discovery"
}

variable "karpenter_ssm_parameter_arns" {
  description = "List of SSM Parameter ARNs that contain AMI IDs launched by Karpenter"
  type        = list(string)
  # https://github.com/aws/karpenter/blob/ed9473a9863ca949b61b9846c8b9f33f35b86dbd/pkg/cloudprovider/aws/ami.go#L105-L123
  default = ["arn:aws:ssm:*:*:parameter/aws/service/*"]
}

variable "karpenter_node_iam_role_arns" {
  description = "List of node IAM role ARNs Karpenter can use to launch nodes"
  type        = list(string)
  default     = ["*"]
}

variable "karpenter_subnet_account_id" {
  description = "Account ID of where the subnets Karpenter will utilize resides. Used when subnets are shared from another account"
  type        = string
  default     = ""
}

variable "karpenter_sqs_queue_arn" {
  description = "(Optional) ARN of SQS used by Karpenter when native node termination handling is enabled"
  type        = string
  default     = null
}

# AWS Load Balancer Controller
variable "attach_load_balancer_controller_policy" {
  description = "Determines whether to attach the Load Balancer Controller policy to the role"
  type        = bool
  default     = false
}

# https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/targetgroupbinding/targetgroupbinding/#reference
# https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/#setup-iam-manually
variable "attach_load_balancer_controller_targetgroup_binding_only_policy" {
  description = "Determines whether to attach the Load Balancer Controller policy for the TargetGroupBinding only"
  type        = bool
  default     = false
}

# AWS Appmesh Controller
variable "attach_appmesh_controller_policy" {
  description = "Determines whether to attach the Appmesh Controller policy to the role"
  type        = bool
  default     = false
}

# AWS Appmesh envoy proxy
variable "attach_appmesh_envoy_proxy_policy" {
  description = "Determines whether to attach the Appmesh envoy proxy policy to the role"
  type        = bool
  default     = false
}

# Amazon Managed Service for Prometheus
variable "attach_amazon_managed_service_prometheus_policy" {
  description = "Determines whether to attach the Amazon Managed Service for Prometheus IAM policy to the role"
  type        = bool
  default     = false
}

variable "amazon_managed_service_prometheus_workspace_arns" {
  description = "List of AMP Workspace ARNs to read and write metrics"
  type        = list(string)
  default     = ["*"]
}

# Velero
variable "attach_velero_policy" {
  description = "Determines whether to attach the Velero IAM policy to the role"
  type        = bool
  default     = false
}

variable "velero_s3_bucket_arns" {
  description = "List of S3 Bucket ARNs that Velero needs access to in order to backup and restore cluster resources"
  type        = list(string)
  default     = ["*"]
}

# VPC CNI
variable "attach_vpc_cni_policy" {
  description = "Determines whether to attach the VPC CNI IAM policy to the role"
  type        = bool
  default     = false
}

variable "vpc_cni_enable_ipv4" {
  description = "Determines whether to enable IPv4 permissions for VPC CNI policy"
  type        = bool
  default     = false
}

variable "vpc_cni_enable_ipv6" {
  description = "Determines whether to enable IPv6 permissions for VPC CNI policy"
  type        = bool
  default     = false
}

# Node termination handler
variable "attach_node_termination_handler_policy" {
  description = "Determines whether to attach the Node Termination Handler policy to the role"
  type        = bool
  default     = false
}

variable "node_termination_handler_sqs_queue_arns" {
  description = "List of SQS ARNs that contain node termination events"
  type        = list(string)
  default     = ["*"]
}
