variable "bucket_name" {
  type = string
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  # basic recommended settings
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = var.bucket_name
    Env  = "dev"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
