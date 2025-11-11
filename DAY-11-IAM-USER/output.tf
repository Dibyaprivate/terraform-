output "user_name" {
  value = aws_iam_user.demo_user.name
}

output "user_policy_arn" {
  value = aws_iam_policy.demo_policy.arn
}

output "access_key_id" {
  description = "Access key ID for the IAM user"
  value       = aws_iam_access_key.demo_key.id
  sensitive   = true
}

output "secret_access_key" {
  description = "Secret access key for the IAM user"
  value       = aws_iam_access_key.demo_key.secret
  sensitive   = true
}

output "role_name" {
  value = aws_iam_role.demo_role.name
}

output "role_arn" {
  value = aws_iam_role.demo_role.arn
}