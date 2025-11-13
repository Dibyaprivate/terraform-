variable "db_name" {
  type = string
}
variable "username" {
  type = string
}
variable "password" {
  type = string
  sensitive = true
}
variable "allocated_storage" {
  type = number
  default = 20
}
variable "instance_class" {
  type = string
  default = "db.t3.micro"
}

# Basic DB subnet group using default VPC subnets (keeps example simple)
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_db_subnet_group" "default" {
  name       = "tf-rds-subnet-group"
  subnet_ids = data.aws_subnet_ids.default.ids
  tags = { Name = "tf-rds-subnet-group" }
}

resource "aws_db_instance" "this" {
  identifier         = "tf-rds-demo"
  allocated_storage  = var.allocated_storage
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = var.instance_class
  name               = var.db_name
  username           = var.username
  password           = var.password
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot = true
  publicly_accessible = true
  # small storage IOPS defaults are fine for demo
  tags = { Name = "tf-rds" }
}

output "db_endpoint" {
  value = aws_db_instance.this.address
}
