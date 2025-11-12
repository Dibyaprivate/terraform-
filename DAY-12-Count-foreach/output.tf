output "instance_ids" {
  value = aws_instance.count_example[*].id
}
output "instance_public_ips" {
  value = aws_instance.count_example[*].public_ip
}
output "instance_type" {
  value = aws_instance.count_example[*].instance_type
}  
output "envs" {
  value = var.env
}