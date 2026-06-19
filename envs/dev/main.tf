############################################
# PROVIDER
############################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

############################################
# IAM (Zero Trust Identity Layer)
############################################

resource "aws_iam_role" "ec2_role" {
  name = "zero-trust-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "zero-trust-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

############################################
# EC2 INSTANCE (existing resource in state)
############################################

resource "aws_key_pair" "this" {
  
  public_key = file("/home/ec2-user/.ssh/id_rsa.pub")
}


resource "aws_instance" "web" {
iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  key_name = aws_key_pair.this.key_name

  subnet_id = "subnet-0525a28ab4ebdcd70"

 
 vpc_security_group_ids = [module.vpc.ec2_sg_id]


  associate_public_ip_address = true

  

  tags = {
    Name = "dev-ec2"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr  = "10.0.0.0/16"
  name       = "dev-vpc"
}

