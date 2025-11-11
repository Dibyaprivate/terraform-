
# S3 bucket in us-east-1
resource "aws_s3_bucket" "bucket_us" {
  bucket = "bucket-multi-provider-us"
}

# S3 bucket in ap-south-1
resource "aws_s3_bucket" "bucket_india" {
  provider = aws.mumbai   # <-- VERY IMPORTANT
  bucket   = "bucket-multi-provider-india"
}