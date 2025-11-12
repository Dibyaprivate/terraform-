# resource "aws_instance" "count_example" {
#   ami           = "ami-07d1f1c6865c6b0e7" # Amazon Linux 2 AMI
#   instance_type = "t2.micro"
#   count = 3
#   tags = {
#     Name = "dev-${count.index + 1}"
#   }

# }
resource "aws_instance" "count_example" {
  ami           = "ami-07d1f1c6865c6b0e7" # Amazon Linux 2 AMI
  instance_type = var.instance_type[count.index]
  count         = length(var.env)
    tags = {
        Name = "${var.env[count.index]}-instance"
    }
}


# What is count in Terraform?

# count is a meta-argument in Terraform that lets you create multiple copies of a resource or module using a single block.

# It helps you avoid writing the same resource again and again.

# 🧩 Basic Idea

# 🗣️ Think of count like saying:

# “Hey Terraform, make this resource this many times!”

# 🧱 Syntax
# resource "aws_instance" "example" {
#   count = 3
#   ami           = "ami-07d1f1c6865c6b0e7"
#   instance_type = "t2.micro"
# }


# 🟢 This will create 3 EC2 instances of the same configuration.

# 📦 Terraform Automatically Creates:

# aws_instance.example[0]

# aws_instance.example[1]

# aws_instance.example[2]

# 💡 You can refer to them using count.index (starts from 0).

# 🧩 Example: Use count.index
# resource "aws_instance" "web" {
#   count = 3
#   ami           = "ami-07d1f1c6865c6b0e7"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "web-server-${count.index + 1}"
#   }
# }


# ✅ Output:

# Instance	Name Tag
# 1	web-server-1
# 2	web-server-2
# 3	web-server-3
# 🧠 Conditional Creation (IF logic using count)

# You can use count with conditional expression.

# Example:

# resource "aws_s3_bucket" "backup" {
#   count = var.enable_backup ? 1 : 0
#   bucket = "my-backup-bucket"
# }


# If enable_backup = true → creates 1 bucket
# If enable_backup = false → creates 0 bucket

# 🧩 Example: Different Names from a List

# You can use count with a list to create many resources with different values.

# variable "instance_names" {
#   default = ["app1", "app2", "app3"]
# }

# resource "aws_instance" "servers" {
#   count         = length(var.instance_names)
#   ami           = "ami-07d1f1c6865c6b0e7"
#   instance_type = "t2.micro"
#   tags = {
#     Name = var.instance_names[count.index]
#   }
# }


# ✅ Creates:

# EC2 with Name = app1

# EC2 with Name = app2

# EC2 with Name = app3

# ⚙️ Using count with Modules

# You can also repeat modules:

# module "ec2_instances" {
#   count = 2
#   source = "./modules/ec2"
#   instance_name = "server-${count.index}"
# }


# This runs the same module twice.

# ⚠️ Important Notes

# Index starts from 0
# → count.index gives the number of the resource starting at 0.

# Changing count can destroy or create resources
# → If you reduce count, Terraform deletes extra resources.

# Cannot use both count and for_each in same resource

# 🔍 Quick Summary Table
# Feature	Description	Example
# Create multiple	Makes many copies	count = 3
# Access index	Use number of each	count.index
# Conditional	Create or skip	count = var.enabled ? 1 : 0
# Dynamic names	Different tags/names	Name = "web-${count.index}"
# 🧪 Mini Practical Example

# main.tf

# provider "aws" {
#   region = "ap-south-1"
# }

# variable "server_names" {
#   default = ["dev", "test", "prod"]
# }

# resource "aws_instance" "server" {
#   count         = length(var.server_names)
#   ami           = "ami-07d1f1c6865c6b0e7"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "server-${var.server_names[count.index]}"
#   }
# }


# 🖥️ Result:
# Terraform creates 3 instances:

# server-dev

# server-test

# server-prod