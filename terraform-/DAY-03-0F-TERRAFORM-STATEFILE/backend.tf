terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-2015"
    key            = "day03/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}
