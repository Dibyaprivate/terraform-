########################################
# PROVIDER CONFIGURATION
# ----------------------
# This file tells Terraform:
#  → which provider to use (AWS)
#  → which version of Terraform & AWS provider
#  → which region to deploy the resources in
########################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Minimum Terraform version required
  required_version = ">= 1.6.0"
}

# Provider block - defines region for AWS operations
provider "aws" {
  region = var.aws_region
}
