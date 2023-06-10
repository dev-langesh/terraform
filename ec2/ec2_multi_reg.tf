terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    alias = "ap-south"
  region = "ap-south-1"
}

resource "aws_security_group" "ec2_multi" {
  name        = "eks-test"
  description = "Allow ssh inbound traffic"

  ingress {
    description      = "ssh access to public"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http access to public"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "ap-south" {
  ami = "ami-049a62eb90480f276"
  instance_type = var.instance_type
  key_name = var.key

  vpc_security_group_ids = [aws_security_group.ec2_multi.id]

  user_data = <<EOF
   #!/bin/bash
   yum update -y
   yum install -y httpd
   systemctl start httpd
   systemctl enable httpd
   echo "$(hostname -f) ap-south-1" > /var/www/html/index.html
   EOF

  tags = {
    "Name" = "ap-south-1"
  }
}

provider "aws" {
    alias = "us-east"
  region = "us-east-1"
}

resource "aws_instance" "us-east-1" {
  ami = "ami-04a0ae173da5807d3"
  instance_type = var.instance_type
  key_name = var.key

  vpc_security_group_ids = [aws_security_group.ec2_multi.id]

  user_data = <<EOF
   #!/bin/bash
   yum update -y
   yum install -y httpd
   systemctl start httpd
   systemctl enable httpd
   echo "$(hostname -f) us-east-1" > /var/www/html/index.html
   EOF

  tags = {
    "Name" = "us-east-1"
  }
}

provider "aws" {
    alias = "us-east-2"
  region = "us-east-2"
}

resource "aws_instance" "us-east-2" {
  ami = "ami-092b51d9008adea15"
  instance_type = var.instance_type
  key_name = var.key

  vpc_security_group_ids = [aws_security_group.ec2_multi.id]

   user_data = <<EOF
   #!/bin/bash
   yum update -y
   yum install -y httpd
   systemctl start httpd
   systemctl enable httpd
   echo "$(hostname -f) us-east-2" > /var/www/html/index.html
   EOF

  tags = {
    "Name" = "us-east-2"
  }
}