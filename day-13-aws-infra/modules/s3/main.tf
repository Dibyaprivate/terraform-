variable "bucket_name" {
  type = string
}

# MAIN BUCKET RESOURCE
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  # recommended
  tags = {
    Name = var.bucket_name
    Env  = "dev"
  }
}

# FIX: versioning must be a separate resource
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Optional ACL - new providers require separate resource
# resource "aws_s3_bucket_acl" "bucket_acl" {
#   bucket = aws_s3_bucket.this.id
#   acl    = "private"
# }

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
