terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Define the provider (AWS)
provider "aws" {
  region = "us-east-1"  # Modify the region as needed
}

# Create a security group with open ports
resource "aws_security_group" "production_security_group" {
  name_prefix = "production-sg-"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9010
    to_port     = 9010
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9011
    to_port     = 9011
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instance
resource "aws_instance" "production_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"  # Ubuntu, 22.04 LTS, amd64
  instance_type = "t2.micro"
  key_name      = "practice-key"  # Use your existing key pair name
  security_groups = [aws_security_group.production_security_group.name]
  tags = {
    Name = "production server"
  }

  root_block_device {
    volume_size = 20
  }
}
