variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}
variable "s3_bucket_name" {
  description = "Name of the S3 bucket for Terraform state locking"
  type        = string
}