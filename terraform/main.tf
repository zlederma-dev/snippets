terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "snippets" {
  name        = "snippets-frontend-sg"
  description = "Allow SSH, HTTP, and HTTPS from my IP only"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "snippets-frontend-sg"
  }
}

data "aws_iam_role" "snippets_ec2" {
  name = "snippets-ec2-ecr-pull-role"
}

resource "aws_iam_instance_profile" "snippets_ec2" {
  name = "snippets-ec2-ecr-pull-profile"
  role = data.aws_iam_role.snippets_ec2.name
}

resource "aws_instance" "snippets" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.snippets.id]
  iam_instance_profile   = aws_iam_instance_profile.snippets_ec2.name
  key_name               = "EC2_Tutorial"

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -a -G docker ec2-user
    newgrp docker

    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 040982755314.dkr.ecr.us-east-1.amazonaws.com

    docker pull 040982755314.dkr.ecr.us-east-1.amazonaws.com/snippets:088cc6e791cd2f0572b30d63d4ca13c6d29e3ac6

    docker run -d -p 80:80 040982755314.dkr.ecr.us-east-1.amazonaws.com/snippets:088cc6e791cd2f0572b30d63d4ca13c6d29e3ac6
  EOF

  tags = {
    Name = "snippets-server"
  }
}