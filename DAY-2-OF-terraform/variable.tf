########################################
# VARIABLE DECLARATIONS
# ----------------------
# This file defines all configurable inputs
# such as region, instance type, CIDR blocks, etc.
########################################

# ---------- AWS Region ----------
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

# ---------- EC2 Configuration ----------
variable "ami_id" {
  description = "AMI ID for EC2 instance (Amazon Machine Image)"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name to connect to the EC2 instance"
  type        = string
  default     = "akashbn"
}

# ---------- Networking ----------
variable "vpc_cidr" {
  description = "CIDR block for the VPC (defines private IP range)"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone to deploy subnet and EC2"
  type        = string
  default     = "ap-south-1a"
}

# ---------- Security ----------
variable "ssh_port" {
  description = "Port for SSH access (default: 22)"
  type        = number
  default     = 22
}

variable "http_port" {
  description = "Port for HTTP access (default: 80)"
  type        = number
  default     = 80
}

variable "ssh_cidr" {
  description = "Allowed IP range for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "http_cidr" {
  description = "Allowed IP range for HTTP access"
  type        = string
  default     = "0.0.0.0/0"
}
