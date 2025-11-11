

resource "aws_iam_user" "demo_user" {
  name = var.user_name
  path = "/"
}

resource "aws_iam_policy" "demo_policy" {
  name        = "${var.user_name}-policy"
  description = "Policy for ${var.user_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "ec2:Describe*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.demo_user.name
  policy_arn = aws_iam_policy.demo_policy.arn
}

resource "aws_iam_access_key" "demo_key" {
  user = aws_iam_user.demo_user.name
}

resource "aws_iam_role" "demo_role" {
  name = "${var.user_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.demo_role.name
  policy_arn = aws_iam_policy.demo_policy.arn
}
