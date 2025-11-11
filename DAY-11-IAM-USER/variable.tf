variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "user_name" {
  description = "IAM user name"
  type        = string
  default     = "terraform-demo-user"
}