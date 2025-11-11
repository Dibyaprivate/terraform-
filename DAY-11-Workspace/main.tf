# A Terraform workspace is essentially an isolated instance of
#  your Terraform state. It allows you to manage multiple environments 
#  (like dev, staging, prod) using the same Terraform configuration but
#   with separate state files.
provider "aws" {
  
}

resource "null_resource" "example" {
  triggers = {
    workspace = terraform.workspace
  }
}

output "current_workspace" {
  value = terraform.workspace
}
resource "aws_s3_bucket" "name" {
    bucket = "new-s3-buckect-workspacewwww453"
  
}