terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  profile= "default"
  region = "ap-southeast-1"
}

# 2. Get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"] # Filter for official Amazon AMIs

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"] # Pattern for AL2023
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app-servers" {
  instance_type = "t2.micro"
  ami = "data.aws_ami.amazon_linux_2023.id"
  count = 3
  tags = {
    Name = "app-server"
  }
}

