provider "aws" {
  
}

#------------IAM-Role------#

resource "aws_iam_role" "ssm_role" {
  name = "EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"  # EC2 instances can assume this role
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 2 existing AWS managed policy using a data source

data "aws_iam_policy" "ssm_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#  Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.ssm_policy.arn
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "EC2SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}

# An IAM role alone cannot be directly attached to an EC2 instance.

# AWS requires a container called an “instance profile” to link a role to EC2.

# The instance profile is a wrapper around the IAM role.


#----------Role connect to ec2--------#

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0cae6d6fe6048ca2c"
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name = "SSM-Managed-Instance"
  }
}
