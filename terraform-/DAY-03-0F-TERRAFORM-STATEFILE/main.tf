resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "day03-vpc"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "day03-subnet"
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main_subnet.id
  associate_public_ip_address = true
  key_name                = var.key_name
  tags = {
    Name = "day03-ec2"
  }
}
resource "null_resource" "state_moved_message" {
  provisioner "local-exec" {
    command = "echo '✅ Terraform state file has been successfully moved to S3 backend!'"
  }

  triggers = {
    always_run = timestamp()
  }
}
