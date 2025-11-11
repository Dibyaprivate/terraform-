########################################
# VARIABLE VALUES
# ----------------
# This file provides values for the variables defined in variables.tf.
# Terraform automatically loads it during plan/apply.
########################################

aws_region    = "ap-south-1"
ami_id        = "ami-07382eaff1a1e39da"
vpc_cidr      = "10.0.0.0/16"
subnet_cidr   = "10.0.1.0/24"
key_name      = "akashbn"
instance_type = "t2.micro"