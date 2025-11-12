variable "allowed_ports" {
  type = map(string)
  default = {
    22    = "203.0.113.0/24"    # SSH (Restrict to office IP)
    80    = "0.0.0.0/0"         # HTTP (Public)
    443   = "0.0.0.0/0"         # HTTPS (Public)
    8080  = "10.0.0.0/16"       # Internal App (Restrict to VPC)
    9000  = "192.168.1.0/24"    # SonarQube/Jenkins (Restrict to VPN)
    3389  = "10.0.1.0/24"
  }
}

resource "aws_security_group" "devops_project_veera" {
  name        = "devops-project-veera"
  description = "Allow restricted inbound traffic"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
     
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-veera"
  }
}


# In the above example, we defined a variable allowed_ports as a map where each key is a port number and the corresponding value is the CIDR block allowed to access that port. The dynamic block inside the aws_security_group resource iterates over each key-value pair in the map to create individual ingress rules for each port with its specified CIDR block.
# what is map in terraform?In Terraform, a "map" is a data structure that consists of key-value pairs. Each key in the map is unique and is used to access its corresponding value. Maps are useful for organizing related data and can be used in various Terraform configurations, such as variables, resource attributes, and outputs.
# Maps in Terraform are defined using curly braces {} and the syntax for defining a map variable looks like this: 

# 🧠 Goal of This Code
# You are creating an AWS Security Group (devops_project_veera) that:
# Automatically opens multiple ports
# Uses different source IP ranges for each port
# Uses a dynamic block to avoid writing many ingress rules manually

# 🧩 Step 1 — Variable Definition

# variable "allowed_ports" {
#   type = map(string)
#   default = {
#     22    = "203.0.113.0/24"    # SSH (Restrict to office IP)
#     80    = "0.0.0.0/0"         # HTTP (Public)
#     443   = "0.0.0.0/0"         # HTTPS (Public)
#     8080  = "10.0.0.0/16"       # Internal App (Restrict to VPC)
#     9000  = "192.168.1.0/24"    # SonarQube/Jenkins (Restrict to VPN)
#     3389  = "10.0.1.0/24"       # RDP (Restrict to subnet)
#   }
# }

# 🧾 Meaning:
# This variable is a map, where:
# Key = Port Number
# Value = CIDR block (IP range allowed)
# Example:
# Port 22 (SSH) allowed only from office IP 203.0.113.0/24
# Port 80 and 443 open to public
# Port 8080, 9000, 3389 restricted to private ranges

# 🧩 Step 2 — Security Group Resource
# resource "aws_security_group" "devops_project_veera" {
#   name        = "devops-project-veera"
#   description = "Allow restricted inbound traffic"
# Creates one AWS Security Group named devops-project-veera

# Step 3 — Dynamic Ingress Block
#   dynamic "ingress" {
#     for_each = var.allowed_ports
#     content {
#       description = "Allow access to port ${ingress.key}"
#       from_port   = ingress.key
#       to_port     = ingress.key
#       protocol    = "tcp"
#       cidr_blocks = [ingress.value]
#     }
#   }

# 🔍 What’s Happening Here:

# dynamic "ingress" → tells Terraform to dynamically generate multiple ingress blocks (one per port).

# for_each = var.allowed_ports → loops through your map.

# Terraform reads:

# {
#   22 = "203.0.113.0/24"
#   80 = "0.0.0.0/0"
#   ...
# }


# So it loops through each pair of port and IP range.
# Inside content { ... }
# ingress.key = the map key (the port number)
# ingress.value = the map value (the CIDR range)
# Terraform will automatically expand it into multiple ingress rules, like this:
# 🔧 Terraform Will Generate Internally:
# Equivalent to writing manually:
# ingress {
#   description = "Allow access to port 22"
#   from_port   = 22
#   to_port     = 22
#   protocol    = "tcp"
#   cidr_blocks = ["203.0.113.0/24"]
# }

# ingress {
#   description = "Allow access to port 80"
#   from_port   = 80
#   to_port     = 80
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
# }

# ingress {
#   description = "Allow access to port 443"
#   from_port   = 443
#   to_port     = 443
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
# }

# # ... and so on for 8080, 9000, 3389


# So Terraform writes all these blocks automatically for you — clean and DRY (Don’t Repeat Yourself).

# 🧩 Step 4 — Egress Rule
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


# This means:

# Allow all outbound traffic (to anywhere, all ports, all protocols).

# This is a default rule in most security groups.

# 🏷️ Step 5 — Tags
#   tags = {
#     Name = "devops-project-veera"
#   }
# }


# Adds a tag to the Security Group for easy identification in the AWS console.

# 🧠 Summary — What This Code Does
# Concept	Description
# map(string) variable	Holds port → IP range pairs
# for_each in dynamic	Loops through the map to create many ingress rules
# ingress.key	Port number
# ingress.value	CIDR IP allowed
# egress	Allows all outbound traffic
# Output	One clean Security Group with multiple, auto-generated inbound rules
# 🧪 Output Example (What Terraform Creates)

# Security Group: devops-project-veera
# Inbound rules:

# Port	Source	                         Description
# 22	    203.0.113.0/24	              Allow access to port 22
# 80	    0.0.0.0/0	                  Allow access to port 80
# 443	    0.0.0.0/0	                  Allow access to port 443
# 8080	10.0.0.0/16	                  Allow access to port 8080
# 9000	192.168.1.0/24	              Allow access to port 9000
# 3389	10.0.1.0/24	                  Allow access to port 3389

# 💡 Why This is a Great Design
# ✅ You can add/remove ports easily — just change the map.
# ✅ Keeps your Terraform code clean and short.
# ✅ Reduces human error when managing multiple ports.
# ✅ Easy to reuse across environments (dev/test/prod).
