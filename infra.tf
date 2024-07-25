# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0" #check latest https://registry.terraform.io/providers/hashicorp/aws/latest
    }
    serverscom = {
      source = "serverscom/serverscom"
      version = "0.4.2"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "web" {
  ami                    = "ami-012c2e8e24e2ae21d" #this is now hard coded, need to figure out how to do the aboe way that is commented out atm
  instance_type          = "t2.micro"
  tags = {
    Name = "owasp-js"
  }
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum upgrade
                curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
                sudo yum install -y git htop wget
              EOF
}

resource "aws_security_group" "web-sg" {
  name = "juice-shop-sg"
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
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
