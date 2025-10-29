output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main_subnet.id
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
output "instance_id" {
  value = aws_instance.web.id
}
output "instance_public_dns" {
  value = "${aws_instance.web.public_dns}"
}
output "success_message" {
  value = "✅ Terraform state file has been successfully moved to S3 backend and infrastructure deployed!"
}
