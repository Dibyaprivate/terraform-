terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Modules
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = var.instance_type
  key_name      = var.key_name
}

module "rds" {
  source            = "./modules/rds"
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  allocated_storage = var.db_allocated_storage
  instance_class    = var.db_instance_class
}

module "lambda" {
  source        = "./modules/lambda"
  function_name = var.lambda_function_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  s3_bucket     = module.s3.bucket_name   # Lambda can reference S3 if you upload code there; not required for filename method below
  filename      = var.lambda_filename     # local zip path e.g. "lambda/lambda.zip"
}

module "eventbridge" {
  source        = "./modules/eventbridge"
  rule_name     = var.event_rule_name
  schedule_expr = var.event_schedule_expr
  lambda_arn    = module.lambda.lambda_arn
}

# optional iam module that can attach policies to an existing role/name
module "iam" {
  source      = "./modules/iam"
  role_name   = module.lambda.lambda_role_name
  attach_arns = var.iam_extra_policy_arns
}
