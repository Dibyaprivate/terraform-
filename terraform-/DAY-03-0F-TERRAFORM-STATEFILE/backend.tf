
# Note: Ensure that the S3 bucket "my-terraform-state-bucket-2015" exists in the "ap-south-1" region before initializing the backend.
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-2015"
    key            = "day03/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    sensitive_file = true
  }
}
