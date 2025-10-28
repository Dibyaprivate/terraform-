########################################
# OUTPUTS
# --------
# This file displays useful information
# after Terraform applies the configuration.
########################################

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.my_vpc.id
}

output "subnet_id" {
  description = "The ID of the created Subnet"
  value       = aws_subnet.my_subnet.id
}

output "security_group_id" {
  description = "The ID of the created Security Group"
  value       = aws_security_group.my_sg.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_instance.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.my_instance.public_dns
}
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.my_instance.id
}