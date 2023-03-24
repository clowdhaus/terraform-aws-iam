output "irsa_arn" {
  description = "ARN of IAM role"
  value       = module.irsa.arn
}

output "irsa_name" {
  description = "Name of IAM role"
  value       = module.irsa.name
}

output "irsa_path" {
  description = "Path of IAM role"
  value       = module.irsa.path
}

output "irsa_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.irsa.unique_id
}
