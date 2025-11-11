#############################################
# AWS RDS MySQL Setup + SQL Initialization  #
#############################################

provider "aws" {
  region = "us-east-1"
}

# ---------- Create RDS MySQL Instance ----------
resource "aws_db_instance" "mysql_rds" {
  identifier              = "my-mysql-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "Password123!"
  db_name                 = "dev"
  allocated_storage       = 20
  skip_final_snapshot     = true
  publicly_accessible     = true

  tags = {
    Name = "MySQL-RDS-Demo"
  }
}

# ---------- Run Local SQL Script After RDS Creation ----------
resource "null_resource" "local_sql_exec" {
  depends_on = [aws_db_instance.mysql_rds]

  provisioner "local-exec" {
    interpreter = ["cmd", "/C"]
    command     = "\"\"C:\\Program Files\\MySQL\\MySQL Server 8.0\\bin\\mysql.exe\" -h my-mysql-db.cq3e0u2k6xee.us-east-1.rds.amazonaws.com -u admin -pPassword123! dev < \"E:\\terraform\\terraform-\\terraform-\\DAY-1O-PROVISIONERS-NULL-RESOURCES\\local-exec-null\\init.sql\"\""
  }

  triggers = {
    always_run = timestamp()
  }
}
# Note: Adjust the MySQL client path and SQL file path as per your local setup.
# Ensure that your local machine can access the RDS instance (e.g., security group settings).
# Also, make sure the MySQL client is installed on your local machine.
# -------------------------------------------------------------------------------------------------
# Additional Notes:   
# - The local-exec provisioner runs a command on the machine where Terraform is executed.
# - The null_resource is used here to trigger the local-exec provisioner after the RDS instance is created.
# - The triggers block with timestamp() ensures that the provisioner runs every time 'terraform apply' is executed.
# - Ensure that the RDS instance is accessible from your local machine (consider VPC, security groups, etc.).     
# - Adjust the MySQL command as per your OS (the example is for Windows; for Linux/Mac, use appropriate shell commands).
# - Be cautious with hardcoding sensitive information like database passwords; consider using environment variables or secret management solutions for production setups.
# -------------------------------------------------------------------------------------------------                 
# Example EC2 instance (replace with yours if already existing)
