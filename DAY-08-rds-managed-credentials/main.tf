# ------------------------------
# Create a VPC for the database
# ------------------------------
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dev"
  }

  # Description: This VPC provides network isolation for our RDS setup.
}

# ------------------------------------------
# Create Subnet 1 (Availability Zone: 1a)
# ------------------------------------------
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-1"
  }

  # Description: First private subnet for RDS in AZ 1a.
}

# ------------------------------------------
# Create Subnet 2 (Availability Zone: 1b)
# ------------------------------------------
resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-2"
  }

  # Description: Second private subnet for RDS in AZ 1b.
}

# ---------------------------------------------------
# Create a DB Subnet Group for the RDS Instance
# ---------------------------------------------------
resource "aws_db_subnet_group" "sub_grp" {
  name       = "mycutsubnett"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "My DB subnet group"
  }

  # Description: Groups subnets from multiple AZs for RDS high availability.
}

# ----------------------------------------------------
# Create an RDS MySQL Database Instance
# ----------------------------------------------------
resource "aws_db_instance" "default" {
  identifier                  = "book-rds"
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.micro"
  allocated_storage           = 10
  username                    = "admin"
  manage_master_user_password = true   # Secrets Manager manages the password securely

  db_subnet_group_name        = aws_db_subnet_group.sub_grp.name
  parameter_group_name        = "default.mysql8.0"

  backup_retention_period     = 7       # Retain automated backups for 7 days
  backup_window               = "02:00-03:00"  # Daily backup window (UTC)
  maintenance_window          = "sun:04:00-sun:05:00"  # Weekly maintenance
  deletion_protection         = true    # Prevent accidental deletion
  skip_final_snapshot         = true    # Skip snapshot when deleting (use carefully)

  tags = {
    Name = "MySQL-RDS"
  }

  depends_on = [aws_db_subnet_group.sub_grp]

  # Description: This resource creates a MySQL 8.0 RDS instance in a private VPC.
}
