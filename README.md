# Terraform Daily Practice
This repository is dedicated to documenting my daily practice of Terraform, an infrastructure as code (IaC) tool by HashiCorp. Here, I'll be sharing my journey of learning and using Terraform to manage and automate infrastructure resources.

## What to Expect

- **Regular Updates:** Expect regular updates as I explore Terraform's capabilities and features.

- **Code Examples:** I'll provide code snippets, configurations, and real-world use cases to help you understand how to use Terraform effectively.

- **Best Practices:** I'll share best practices and tips I discover along the way to ensure clean, maintainable, and scalable Terraform code.

- **Challenges:** I'll tackle common challenges and roadblocks that I encounter during my Terraform journey, along with solutions and workarounds.

Feel free to explore this repository, ask questions, and contribute to the learning process. Let's embark on this Terraform adventure together!

## Contents
- [Day 1: Provision an AWS EC2](#day1-provision-an-aws-ec2)

<!-- - [Day 2: Creating Your First Resource](#day2-creating-your-first-resource) -->
<!-- - [Day 3: Managing Variables](#day1-managing-variables) -->

<!-- # Day 1: Setting up Terraform -->
--------------

# Day 1: Provision an AWS EC2 

## Part A: Basic AWS EC2 Provisioning  

Following code, in file `main.tf`, is being used to provision an AWS ec2. 

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
```

**Explaination of above code:**

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}
```

- The `terraform` block defines the configuration for the Terraform project.
    - `required_providers` specifies the providers used in this configuration. In this case, it's using the AWS provider, which is provided by HashiCorp (source: "hashicorp/aws").
        - `version` specifies the required version of the AWS provider. It's set to "~> 4.16," meaning it will use any version from 4.16 up to the next major release.
    - `required_version` specifies the minimum required Terraform version. In this case, it's ">= 1.2.0," indicating that you need at least Terraform version 1.2.0 to use this configuration.

```
provider "aws" {
  region  = "us-east-1"
}
```

- The `provider` block defines the configuration for the AWS provider.
    - `aws` is the name of the provider you're configuring.
    - `region` specifies the AWS region in which the resources will be created. In this case, it's set to "us-east-1."

```
resource "aws_instance" "app_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
```

- The `resource` block is used to declare an AWS EC2 instance.
    - `aws_instance` is the resource type, and "app_server" is a local name or identifier for this specific instance. You can refer to this instance elsewhere in your configuration using this name.
    - `ami` specifies the Amazon Machine Image (AMI) ID to use for the instance. In this case, it's using a specific AMI ID.
    - `instance_type` specifies the instance type, which is "t2.micro" in this example (a small, low-cost instance type).
    - `tags` is a map of key-value pairs that represent tags to associate with the EC2 instance. In this example, there's one tag named "Name" with the value "ExampleAppServerInstance."

## Part B: AWS EC2 Provisioning with Custom Security Group  

The following Terraform configuration creates an EC2 instance with:
- in `us-east-1` region
- having name `production_server`
- with security group `production_security_group`, and open ports are 22, 80, 443, 9010, 9011
- operating system `Ubuntu, 22.04 LTS, amd64` having AMI `ami-0fc5d935ebf8bc3bc`
- instance type `t2.micro`
- key-pair name `practice-key`
- block storage 20 GB

**main.tf file contains following code:**

```
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
    Name = var.instance_name
  }

  root_block_device {
    volume_size = 20
  }
}
```

**variables.tf file contains following code:**
```
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "production server"
}
```


<!-- # Day 1: Setting up Terraform -->
<!-- # Day 1: Setting up Terraform -->

