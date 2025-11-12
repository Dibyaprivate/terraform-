# What is for_each in Terraform?

# for_each is also a meta-argument (like count) that lets you create multiple resources, but it works with maps or sets of strings instead of just numbers.

# It gives better control and meaningful names for each resource.

# 💡 Simple Difference Between count and for_each
# Feature	count	for_each
# Works with	Number (e.g., 3) or list	Map or Set
# Access by	Index number ([0], [1])	Key name (each.key)
# Output name	resource[index]	resource["key"]
# Recommended for	Simple lists	Named items (maps)
# Changing order	Can destroy & recreate	Safer, keeps mapping
# 🧩 Example 1 — Using count
variable "names" {
  default = ["app1", "app2", "app3"]
}

resource "aws_instance" "example" {
  count         = length(var.names)
  ami           = "ami-07d1f1c6865c6b0e7"
  instance_type = "t2.micro"
  tags = {
    Name = var.names[count.index]
  }
}


# 🟢 Output:

# aws_instance.example[0] → app1

# aws_instance.example[1] → app2

# aws_instance.example[2] → app3

# 🧩 Example 2 — Using for_each
variable "servers" {
  default = {
    dev  = "t2.micro"
    test = "t2.small"
    prod = "t2.medium"
  }
}

resource "aws_instance" "server" {
  for_each = var.servers
  ami           = "ami-07d1f1c6865c6b0e7"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}


# 🟢 Output:

# aws_instance.server["dev"]

# aws_instance.server["test"]

# aws_instance.server["prod"]

# Each instance has a different size and tag!

# 🧩 Access Inside Resource
# Inside resource	Description
# each.key	The map key (like dev, prod)
# each.value	The value (like t2.micro, t2.medium)
# ⚙️ Example 3 — Using for_each with List (converted to Set)

# If you have a list, convert it to a set like this:

variable "names2" {
  default = ["frontend", "backend", "database"]
}

resource "aws_s3_bucket" "example" {
  for_each = toset(var.names2)
  bucket = "my-${each.key}-bucket"
}


# 🟢 Creates buckets:

# my-frontend-bucket

# my-backend-bucket

# my-database-bucket

# 🧩 Example 4 — Using for_each in Modules
variable "envs" {
  default = {
    dev  = "10.0.0.0/24"
    test = "10.0.1.0/24"
  }
}

module "vpc1" {
  for_each = var.envs
  source   = "./modules/vpc1"
  cidr_block = each.value
  env_name   = each.key
}


# ✅ Creates separate VPC for dev and test environments.

# ⚠️ Important Notes

# for_each gives stable names (better for big infra).

# You can’t use both count and for_each in the same resource.

# Use for_each when you have key-value pairs.

# Use count when you have a list or a simple repeat.

# 🧾 Quick Comparison Table
# Use Case	Prefer
# Repeat same resource X times	count
# Create resources with names (dev, test, prod)	for_each
# Each item needs different values	for_each
# You only have a list of items	count or for_each(toset())
# 🧪 Mini Practical Example – Count vs For_Each
# Using count
variable "names3" {
  default = ["web1", "web2", "web3"]
}

resource "aws_instance" "web" {
  count = length(var.names3)
  ami = "ami-07d1f1c6865c6b0e7"
  instance_type = "t2.micro"
  tags = {
    Name = var.names3[count.index]
  }
}

# Using for_each
variable "servers3" {
  default = {
    dev = "t2.micro"
    prod = "t2.medium"
  }
}

resource "aws_instance" "servers3" {
  for_each = var.servers3
  ami = "ami-07d1f1c6865c6b0e7"
  instance_type = each.value
  tags = {
    Name = each.key
  }
}

# 🧠 Final Summary
# Feature	count	for_each
# Input Type	Number / List	Map / Set
# Index Type	Numeric	Key-based
# Access Variable	count.index	each.key, each.value
# Naming Style	resource[0]	resource["name"]
# Flexibility	Basic	More advanced
# Best For	Simple duplicates	Named, unique resources