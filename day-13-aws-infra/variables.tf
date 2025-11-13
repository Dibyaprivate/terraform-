variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name (to SSH)"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "demo_db"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  default     = "Admin1234!"
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "RDS allocated storage (GB)"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "demo_lambda"
}

variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.9"
}

variable "lambda_filename" {
  description = "Local path to zipped lambda code (optional if you want to use s3_bucket/s3_key)"
  type        = string
  default     = "lambda/lambda.zip"
}

variable "event_rule_name" {
  description = "EventBridge rule name"
  type        = string
  default     = "daily-trigger"
}

variable "event_schedule_expr" {
  description = "Schedule expression for EventBridge (rate or cron)"
  type        = string
  default     = "rate(1 day)"
}

variable "iam_extra_policy_arns" {
  description = "Optional list of additional policy ARNs to attach to lambda role"
  type        = list(string)
  default     = []
}
