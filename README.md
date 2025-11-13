My Terraform Journey — Complete Hands-On Repository
Welcome to my Terraform Learning Repository!
This repo is a personal notebook and practice workspace where I’m learning, experimenting, and mastering Terraform — the most powerful Infrastructure as Code (IaC) tool.
It contains day-wise practice files, notes, and real AWS examples that I created while following a structured 20-day roadmap — from basic setup to advanced real-world deployment.

🌍 Terraform Full Course — 20-Day Learning Notebook
🧭 Day 1 – Introduction to IaC & Terraform
Infrastructure as Code (IaC) means writing code to create and manage servers, networks, and databases automatically.
Terraform is the most popular IaC tool developed by HashiCorp.
🧠 Concepts
IaC automates infrastructure instead of using manual clicks.
Terraform works with many providers – AWS, Azure, GCP, Kubernetes, etc.
It uses HCL (HashiCorp Configuration Language).

🧩 Commands
terraform version
terraform -help

🏗️ Example
resource "aws_instance" "demo" {
  ami           = "ami-0abcd1234"
  instance_type = "t2.micro"
}

🎯 Practice

Install Terraform, AWS CLI, and create your first EC2 instance.

⚙️ Day 2 – Terraform Setup and Configuration
🧠 Steps

Install Terraform binary.

Configure AWS CLI using:

aws configure


Create files:

main.tf → infrastructure

variables.tf → inputs

outputs.tf → results

🧩 Commands
terraform init
terraform plan
terraform apply
terraform destroy

🏗️ Example
provider "aws" {
  region = "us-east-1"
}

🔌 Day 3 – Providers and Authentication

Providers connect Terraform to a specific platform.

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

🧠 Authentication Methods

Environment variables

Shared credentials file

AWS CLI profile

EC2 instance role

🎯 Practice

Use two providers (aws & random) in a single project.

📊 Day 4 – Variables, Outputs & Data Sources
🧩 Variables
variable "instance_type" {
  description = "EC2 Type"
  default     = "t2.micro"
}


Use with:

instance_type = var.instance_type

🧩 Outputs
output "public_ip" {
  value = aws_instance.demo.public_ip
}

🧩 Data Source
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
}

💾 Day 5 – Terraform State File & Remote Backend

terraform.tfstate tracks deployed resources.

Keep it safe and never edit manually.

🧩 Remote Backend (S3)
backend "s3" {
  bucket         = "terraform-state-bucket"
  key            = "prod/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-lock"
  encrypt        = true
}

🧠 Commands
terraform state list
terraform show

🔒 Day 6 – State Locking & Terraform Cloud

State Locking prevents simultaneous updates.

Use DynamoDB for locking.

Terraform Cloud provides remote state + team features.

🌐 Day 7 – Custom Networking (VPC, Subnet, Routes)
🧩 Example
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}


🧠 Practice — Build a VPC + Subnet + EC2 Instance.

🎯 Day 8 – Resource Targeting & Lifecycle
🧩 Target Specific Resource
terraform apply -target=aws_instance.web

🧩 Lifecycle Block
lifecycle {
  prevent_destroy = true
  ignore_changes  = [tags]
}

🧱 Day 9 – Terraform Import

Import existing AWS resources:

terraform import aws_instance.web i-0abcd1234


Then run terraform plan to sync.

🧩 Day 10 – Modules (Parent & Child)
🧠 Concept

Modules = Reusable code blocks.

Child module (main.tf)

resource "aws_instance" "server" {
  ami           = "ami-0abcd1234"
  instance_type = var.instance_type
}


Root module

module "web" {
  source = "./modules/ec2"
  instance_type = "t2.micro"
}

⚙️ Day 11 – Provisioners
🧩 local-exec
provisioner "local-exec" {
  command = "echo ${self.public_ip} >> ip.txt"
}

🧩 remote-exec
provisioner "remote-exec" {
  inline = ["sudo apt update", "sudo apt install nginx -y"]
}

🧩 null_resource

Used to run scripts without creating a cloud resource.

🗂️ Day 12 – Workspaces

Workspaces separate environments (dev/test/prod).

terraform workspace new dev
terraform workspace select dev
terraform workspace list


Use in variables:

name = "app-${terraform.workspace}"

🧮 Day 13 – Locals, Conditions, Meta-Arguments
locals {
  env = "dev"
}

resource "aws_instance" "demo" {
  instance_type = local.env == "dev" ? "t2.micro" : "t2.small"
}


Meta-arguments like depends_on, count, and for_each manage order and repetition.

🔁 Day 14 – Count & For-Each
resource "aws_instance" "server" {
  count = 3
  ami   = "ami-0abcd1234"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "b" {
  for_each = toset(["dev","test","prod"])
  bucket   = "my-bucket-${each.key}"
}

🌏 Day 15 – Multiple Providers / Multi-Account
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "aws_instance" "west" {
  provider = aws.west
  ami      = "ami-0abcd1234"
  instance_type = "t2.micro"
}

⚡ Day 16 – Taint & Replace Resources

Force recreation:

terraform taint aws_instance.web
terraform apply

🔐 Day 17 – Security Groups with CIDR
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

🧩 Day 18 – Lambda, RDS, IAM Examples
🧠 Lambda
resource "aws_lambda_function" "demo" {
  filename      = "lambda.zip"
  function_name = "demo-function"
  handler       = "index.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda.arn
}

🧠 RDS
resource "aws_db_instance" "db" {
  engine         = "mysql"
  instance_class = "db.t3.micro"
  username       = "admin"
  password       = "pass1234"
  skip_final_snapshot = true
}

🧠 IAM
resource "aws_iam_role" "lambda" {
  name = "lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

📘 Day 19 – Best Practices & Real Project

Keep modules small & reusable.

Always run terraform fmt and terraform validate.

Store state remotely (S3 + DynamoDB).

Use .tfvars for secrets.

Version-lock providers.

🧠 Project – Build a 3-tier AWS architecture (VPC + EC2 + RDS).

💬 Day 20 – Interview & Practice
Common Questions

Difference between Terraform & CloudFormation

Explain .tfstate and backends

How does terraform plan work?

How do you handle drift?

What are workspaces?

Quick Commands
terraform init
terraform plan
terraform apply
terraform destroy

🧠 Bonus Practice Ideas

Generate docs with terraform-docs.

Integrate Terraform with GitHub Actions.

Use in CI/CD pipelines.

👩‍💻 Author

Dibya
🌱 Terraform | AWS | DevOps Learner
📂 GitHub: Dibyaprivate
