########################################
# MAIN INFRASTRUCTURE RESOURCES
# -----------------------------
# This file defines all AWS resources:
#  → VPC
#  → Subnet
#  → Internet Gateway
#  → Route Table & Association
#  → Security Group
#  → EC2 Instance
########################################

# ---------- VPC ----------
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "guardians-vpc"
  }
}

# ---------- Subnet ----------
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "guardians-public-subnet"
  }
}

# ---------- Internet Gateway ----------
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "guardians-igw"
  }
}

# ---------- Route Table ----------
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  # Route all outbound traffic (0.0.0.0/0) to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "guardians-route-table"
  }
}

# ---------- Route Table Association ----------
resource "aws_route_table_association" "my_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# ---------- Security Group ----------
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "guardians-sg"

  # Inbound SSH (port 22)
  ingress {
    description = "Allow SSH access"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  # Inbound HTTP (port 80)
  ingress {
    description = "Allow HTTP access"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.http_cidr]
  }

  # Outbound traffic allowed to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "guardians-sg"
  }
}

# ---------- EC2 Instance ----------
resource "aws_instance" "my_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.my_subnet.id
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  # Optional: Install NGINX web server automatically on instance launch
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Welcome to Team Pipeline Guardians!</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "guardians-ec2"
  }
}
