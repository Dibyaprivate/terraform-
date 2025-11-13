output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "ec2_public_ip" {
  value = module.ec2.instance_public_ip
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "event_rule_arn" {
  value = module.eventbridge.rule_arn
}
