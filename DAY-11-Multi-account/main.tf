resource "aws_instance" "name" {
  ami="ami-0cae6d6fe6048ca2c" 
  instance_type = "t3.micro"
  tags = {
    Name = "MultiAccount-Instance"
  }

}

resource "aws_s3_bucket" "name" {
    bucket = "my-multi-account-bucket-rohit453"
    provider = aws.oregon
}