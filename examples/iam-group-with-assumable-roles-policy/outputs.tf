output "iam_account_id" {
  description = "IAM AWS account id (this code is managing resources in this account)"
  value       = data.aws_caller_identity.iam.account_id
}

output "production_account_id" {
  description = "Production AWS account id"
  value       = data.aws_caller_identity.production.account_id
}
