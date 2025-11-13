provider "aws" {
  
}
resource "aws_instance" "import" {
    ami = "ami-0cae6d6fe6048ca2c"
    instance_type = "t3.micro" 
    tags = {
        Name = "ec2"
    }
}
#terraform import aws_instance.import i-09f19cc3a66cde854