#  variable "portname" {
#    type = list(number)
#    default = [22, 80, 443, 8080, 9000, 3000, 8082, 8081, 3306]
#  }
 
#  resource "aws_security_group" "devops-project-veera" {
#   name        = "devops-project-veera"
#   description = "Allow TLS inbound traffic"

#   ingress = [
     
#     for port in var.portname : {
#       description      = "inbound rules"
#       from_port        = port
#       to_port          = port
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     }
#   ]

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "devops-project-veera"
#   }
# }

#optional:2 Using dynamic block (best practice)
variable "ports" {
  default = [22, 80, 443, 8080, 9000, 3000, 8082, 8081, 3306]
}

resource "aws_security_group" "devops_project_veera" {
  name        = "devops-project-veera"
  description = "Allow inbound traffic"
  vpc_id      = "vpc-05fc6ad722f51c9a5" # Replace with your VPC ID

  dynamic "ingress" {
    for_each = var.ports
    content {
      description      = "Allow port ${ingress.value}"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      self             = false
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-veera"
  }
}
#Option 2: Using locals and list comprehension (advanced)
# If you don’t want to use dynamic, you can build a list of ingress blocks like this:/

# locals {
#   ports = [22, 80, 443, 8080, 9000, 3000, 8082, 8081, 3306]

#   ingress_rules = [
#     for port in local.ports : {
#       description      = "Allow inbound traffic on port ${port}"
#       from_port        = port
#       to_port          = port
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = []
#       self             = false
#     }
#   ]
# }

# resource "aws_security_group" "devops_project_veera" {
#   name        = "devops-project-veera"
#   description = "Allow inbound traffic"
#   vpc_id      = "vpc-xxxxxxxx"

#   ingress = local.ingress_rules

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "devops-project-veera"
#   }
# }
# ✅ This also works, using Terraform’s list comprehension syntax.

# 🧠 Summary
# Goal	Correct Way
# Reuse a list of ports	Define a variable or local
# Create multiple ingress rules	Use dynamic "ingress" or for expression in a local
# Don’t	Define a variable inside the resource block
# Good practice	Use maps for different CIDRs per port (like your previous example)