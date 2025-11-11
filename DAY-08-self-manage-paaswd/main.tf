# =========================================
# RDS MySQL Instance with Self-Managed Credentials
# =========================================

resource "aws_db_instance" "default" {
  identifier              = "rds-test"
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10

  # 👇 Self-managed credentials
  username                = "admin"
  password                = "Cloud123"  # ⚠️ Avoid hardcoding in production (see note below)

  # 👇 Network configuration
  db_subnet_group_name    = aws_db_subnet_group.sub_grp.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]  # optional if you want inbound control
  parameter_group_name    = "default.mysql8.0"
  publicly_accessible     = true

  # 👇 Backup & maintenance
  backup_retention_period  = 7
  backup_window            = "02:00-03:00"
  maintenance_window       = "sun:04:00-sun:05:00"
  deletion_protection      = true
  skip_final_snapshot      = true

  # 👇 Monitoring
  monitoring_interval      = 60
  monitoring_role_arn      = aws_iam_role.rds_monitoring.arn

  tags = {
    Name = "MySQL-RDS"
  }

  depends_on = [
    aws_db_subnet_group.sub_grp,
    aws_iam_role_policy_attachment.rds_monitoring_attach
  ]
}

# =========================================
# IAM Role for RDS Enhanced Monitoring
# =========================================
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

# Attach the AWS-managed policy for RDS monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# =========================================
# Data sources to fetch existing subnets by tag
# =========================================
data "aws_subnet" "subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["subnet-1"]
  }
}

data "aws_subnet" "subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["subnet-2"]
  }
}

# =========================================
# DB Subnet Group (using subnet data)
# =========================================
resource "aws_db_subnet_group" "sub_grp" {
  name       = "mycutsubnet"
  subnet_ids = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

# =========================================
# Optional: Security Group for RDS
# =========================================
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow MySQL (3306) access to RDS"
  vpc_id      = data.aws_subnet.subnet_1.vpc_id

  ingress {
    description = "Allow MySQL from your IP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP_ADDRESS/32"]  # Replace with your actual IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Note: In production, avoid hardcoding credentials. Use AWS Secrets Manager or SSM Parameter Store for secure management.