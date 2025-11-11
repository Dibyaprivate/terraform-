##############################################################
# AWS RDS MySQL Primary Instance + Read Replica (Managed Password)
##############################################################

# ------------------------------
# 1. IAM Role for RDS Monitoring
# ------------------------------
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

resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# ------------------------------
# 2. VPC & Networking Setup
# ------------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "rds-vpc" }
}

# Internet Gateway (required for public access)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "rds-igw" }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "rds-public-rt" }
}

# Subnets
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "rds-subnet-1" }
}

resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags                    = { Name = "rds-subnet-2" }
}

# Associate subnets to the public route table
resource "aws_route_table_association" "subnet_1_assoc" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet_2_assoc" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Subnet Group for RDS
resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
  tags       = { Name = "RDS Subnet Group" }
}

# ------------------------------
# 3. Security Group for RDS Access
# ------------------------------
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow MySQL (3306) access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow MySQL from your IP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["27.6.72.187/32"] # Your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "rds-sg" }
}

# ------------------------------
# 4. Primary RDS Instance (AWS-managed password)
# ------------------------------
resource "aws_db_instance" "primary" {
  identifier        = "rds-primary"
  db_name           = "myappdb"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = "admin"
  password          = "MySecurePass123!"

  # AWS-managed password (stored in Secrets Manager)
  # manage_master_user_password = false

  db_subnet_group_name    = aws_db_subnet_group.db_subnet_grp.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = true
  backup_retention_period = 7
  backup_window           = "02:00-03:00"
  maintenance_window      = "sun:04:00-sun:05:00"
  deletion_protection     = true
  skip_final_snapshot     = true

  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  tags = {
    Name = "RDS-Primary"
    Role = "Primary"
  }

  depends_on = [
    aws_db_subnet_group.db_subnet_grp,
    aws_internet_gateway.igw
  ]
}

# ------------------------------
# 5. Read Replica RDS Instance
# ------------------------------
resource "aws_db_instance" "read_replica" {
  identifier             = "rds-read-replica"
  replicate_source_db    = aws_db_instance.primary.arn
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_grp.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  tags = {
    Name = "RDS-ReadReplica"
    Role = "Replica"
  }

  depends_on = [aws_db_instance.primary]
}
