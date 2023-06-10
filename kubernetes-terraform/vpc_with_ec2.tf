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
  region = var.region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "pub-1a" {

    vpc_id = aws_vpc.my_vpc.id

    cidr_block = var.subnet_pub_1a_cidr

    availability_zone = "ap-south-1a"

    map_public_ip_on_launch = true

    tags = {
      Name = "pub-1a"
    }
  
}

resource "aws_subnet" "pub-2b" {

    vpc_id = aws_vpc.my_vpc.id

    cidr_block = var.subnet_pub_2b_cidr

    availability_zone = "ap-south-1b"

    map_public_ip_on_launch = true

    tags = {
      Name = "pub-2a"
    }
  
}

resource "aws_internet_gateway" "my_igw" {
  
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }

  
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my_route_table"
  }

}

resource "aws_route_table_association" "route_table_asso1" {
  route_table_id = aws_route_table.my_route_table.id
  subnet_id = aws_subnet.pub-1a.id
}

resource "aws_network_interface" "my_eni" {
  subnet_id = aws_subnet.pub-1a.id

  private_ips = ["10.0.1.100"]

  tags = {
    Name = "my_eni"
  }
}

resource "aws_route_table_association" "route_table_asso2" {
  route_table_id = aws_route_table.my_route_table.id
  subnet_id = aws_subnet.pub-2b.id
}


# security group

resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow inbound traffic on ports 8000, SSH, HTTP, and HTTPS"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_security_group"
  }
}

resource "aws_instance" "ubuntu" {
  ami = var.ami_id

  instance_type = var.instance_type

  key_name = var.key

  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  subnet_id = aws_subnet.pub-1a.id


  # network_interface {
  #   network_interface_id = aws_network_interface.my_eni.id
  #   device_index = 0
  # }

  user_data = <<-EOF

  #!/bin/bash
  apt install npm -y

  npm i -g npm@latest

  npm i -g n

  n 18.15.0 
  EOF

  

  tags = {
    Name = "ubuntu"
  }
}


# Create EBS volume
resource "aws_ebs_volume" "my_ebs_volume" {
  availability_zone = var.ebs_az
  size              = 20 # Size in GB

  tags = {
    Name = "my_ebs_volume"
  }
}

# Attach EBS volume to EC2 instance
resource "aws_volume_attachment" "my_volume_attachment" {
  device_name = "/dev/xvdf" # Specify the device name to attach the volume to

  volume_id  = aws_ebs_volume.my_ebs_volume.id
  instance_id = aws_instance.ubuntu.id
}


module "sgs" {
  source = "./sg_eks"

  vpc_id = aws_vpc.my_vpc.id

}

module "eks" {
  source = "./eks"

  sg_ids = module.sgs.security_group_public

  vpc_id = aws_vpc.my_vpc.id

  subnet_ids = [aws_subnet.pub-1a.id,aws_subnet.pub-2b.id]
}