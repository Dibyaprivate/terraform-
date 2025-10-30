output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}
output "s3_bucket_name" {
  description = "Name of the S3 bucket used for Terraform state locking"
  value       = aws_s3_bucket.statelock_bucket.bucket
}
