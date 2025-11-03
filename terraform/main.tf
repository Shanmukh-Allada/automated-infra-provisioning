terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
  }
} 
 
provider "aws" {
  region = "us-east-1"
}
resource "aws_security_group" "demo_sg" {
  name        = "demo-sg"
  description = "Allow SSH access"
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all IPs (you can restrict to your IP for security)
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
resource "aws_instance" "demo" {
  ami                         = "ami-0fd3ac4abb734302a"
  instance_type               = "t3.micro"
  key_name                    = "my-terraform-key"
  count                       = 2
  vpc_security_group_ids      = [aws_security_group.demo_sg.id]
  associate_public_ip_address = true
 
  tags = {
    Name = "final${count.index + 1}"
  }
}

output "instance_ips" {
  value = aws_instance.demo[*].public_ip
}
