# AI Agent Instructions for Terraform AWS Infrastructure

## Project Overview
This project manages AWS infrastructure using Terraform, specifically focusing on creating a VPC with associated networking components and EC2 instances in the us-east-1 region.

## Key Components and Architecture

### Infrastructure Components (defined in `main.tf`):
- VPC with CIDR block 10.0.0.0/16
- Public subnet in us-east-1a (10.0.1.0/24)
- Internet Gateway for public internet access
- Route table for internet connectivity
- Security group allowing SSH (22) and HTTP (80) inbound traffic
- EC2 instance running Amazon Linux 2

### Provider Configuration (`provider.tf`):
- AWS provider version 6.18.0
- Region: us-east-1

## Project Conventions

### Resource Naming
- Resources follow a consistent tagging pattern with the "guardians-" prefix for major components
- Example: `guardians-vpc`, `guardians-subnet`, `guardians-ec2-instance`

### Security Configuration
- Security group pattern:
  - Inbound: SSH (22), HTTP (80)
  - Outbound: All traffic allowed
  - Always reference security groups using resource references, not IDs

### Network Architecture
- VPC uses standard 10.0.0.0/16 CIDR
- Subnets follow 10.0.x.0/24 pattern
- Public subnets always have `map_public_ip_on_launch = true`

## Critical Workflows

### Infrastructure Deployment
1. Initialize Terraform:
```bash
terraform init
```

2. Preview changes:
```bash
terraform plan
```

3. Apply changes:
```bash
terraform destroy
```

### Required Configuration
- AWS credentials must be configured
- Key pair named "banty" must exist in the AWS region
- Update the AMI ID if deploying to a different region (current: ami-07d1f1c6865c6b0e7)

## Integration Points
- AWS provider integration via `provider.tf`
- EC2 instance depends on VPC, subnet, and security group resources
- All networking components are interconnected through resource references (e.g., `aws_vpc.my_vpc.id`)

## Development Guidelines
1. Always use resource references instead of hardcoded IDs
2. Maintain the established tagging convention
3. Keep network configurations within the defined CIDR ranges
4. Ensure security group rules are specific and documented