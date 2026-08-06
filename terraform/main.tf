terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# IAM role for EC2 to pull from ECR
resource "aws_iam_role" "ec2_ecr" {
  name = "snippets-ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecr_pull" {
  name = "ecr-pull-policy"
  role = aws_iam_role.ec2_ecr.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = "arn:aws:ecr:us-east-1:040982755314:repository/snippets/*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_ecr" {
  name = "snippets-ec2-ecr-profile"
  role = aws_iam_role.ec2_ecr.name
}

# Fetch current IP at apply time
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"
}

resource "aws_security_group" "snippets" {
  name        = "snippets-sg"
  description = "Allow SSH, HTTP, and HTTPS from current IP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "snippets-sg"
  }
}

# EC2 instance
resource "aws_instance" "snippets" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.small"
  iam_instance_profile   = aws_iam_instance_profile.ec2_ecr.name
  vpc_security_group_ids = [aws_security_group.snippets.id]
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

    docker pull 040982755314.dkr.ecr.us-east-1.amazonaws.com/snippets/frontend:latest
    docker pull 040982755314.dkr.ecr.us-east-1.amazonaws.com/snippets/backend:latest

    docker network create snippets

    docker run -d --name backend --network snippets -p 3001:3001 040982755314.dkr.ecr.us-east-1.amazonaws.com/snippets/backend:latest
    docker run -d --name frontend --network snippets -p 8080:8080 040982755314.dkr.ecr.us-east-1.amazonaws.com/snippets/frontend:latest
  EOF

  tags = {
    Name = "snippets"
  }
}

# Latest Amazon Linux 2023 AMI
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
