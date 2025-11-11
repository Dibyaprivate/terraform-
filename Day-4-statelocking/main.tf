resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "Day04-Terraform-EC2"
  }
}
resource "aws_s3_bucket" "statelock_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "TerraformStateLockBucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.statelock_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


