provider "aws" {
    region = "us-east-1"
  
}

provider "aws" {
    region = "ap-south-1"
    alias = "mumbai"
  
}


# alias used to create multiple configuration inside provider block