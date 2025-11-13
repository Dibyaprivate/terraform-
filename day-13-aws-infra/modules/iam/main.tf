variable "role_name" {
  type = string
  description = "Name of role to attach extra policies to (e.g., lambda role)"
}

variable "attach_arns" {
  type = list(string)
  default = []
}

# Attach any extra policies to the given role (if provided)
resource "aws_iam_role_policy_attachment" "extras" {
  for_each = toset(var.attach_arns)
  role     = var.role_name
  policy_arn = each.value
}
