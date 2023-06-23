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

resource "aws_vpc" "arch_vpc" {
  
  cidr_block = var.aws_vpc_cidr

  tags = {
    "Name" = "arch" 
  }
}

resource "aws_subnet" "pub-1a" {
    vpc_id = aws_vpc.arch_vpc.id
  availability_zone = "ap-south-1a"

  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true

  tags = {
    "Name" = "pub-1a" 
  }
  
}

resource "aws_subnet" "pri-1a" {
  vpc_id = aws_vpc.arch_vpc.id 
  availability_zone = "ap-south-1a"

  cidr_block = "10.0.2.0/24"

  map_public_ip_on_launch = true

  tags = {
    "Name" = "pri-1a" 
  }
}

resource "aws_subnet" "pub-1b" {
  vpc_id = aws_vpc.arch_vpc.id 
  availability_zone = "ap-south-1b"

  cidr_block = "10.0.3.0/24"

  map_public_ip_on_launch = true

  tags = {
    "Name" = "pub-1b" 
  }
}

resource "aws_subnet" "pri-1b" {
  vpc_id = aws_vpc.arch_vpc.id 
  availability_zone = "ap-south-1b"

  cidr_block = "10.0.4.0/24"

  map_public_ip_on_launch = true

  tags = {
    "Name" = "pri-1b" 
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.arch_vpc.id

  tags = {
    "Name" = "my_igw" 
  }
}

resource "aws_route_table" "main_route" {
    vpc_id = aws_vpc.arch_vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "public_route_table" 
  }
}

resource "aws_route_table_association" "rt-asso-pub-1a" {
  subnet_id = aws_subnet.pub-1a.id
  route_table_id = aws_route_table.main_route.id
}

resource "aws_route_table_association" "rt-asso-pub-1b" {
  subnet_id = aws_subnet.pub-1b.id
  route_table_id = aws_route_table.main_route.id
}

resource "aws_eip" "nat_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.pub-1a.id

  allocation_id = aws_eip.nat_ip.id

  tags = {
    "Name" = "nat" 
  }
}

resource "aws_route_table" "private_route_table" {
  
  vpc_id = aws_vpc.arch_vpc.id

  tags = {
    "Name" = "Private route table"
  }

}

resource "aws_route" "private_route" {
  nat_gateway_id = aws_nat_gateway.nat.id
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
}

# resource "aws_route" "private_to_public" {
#   destination_cidr_block = aws_subnet.pub-1a.cidr_block
#   route_table_id = aws_route_table.private_route_table.id
#   gateway_id = aws_internet_gateway.igw.id
# }

resource "aws_route_table_association" "rt-asso-pri-1a" {
    route_table_id = aws_route_table.private_route_table.id
    subnet_id = aws_subnet.pri-1a.id
}

resource "aws_route_table_association" "rt-asso-pri-1b" {
    route_table_id = aws_route_table.private_route_table.id
    subnet_id = aws_subnet.pri-1b.id
}

resource "aws_security_group" "worker_node_sg" {
  name        = "eks-test"
  description = "Allow ssh inbound traffic"
  vpc_id      =  aws_vpc.arch_vpc.id

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

# resource "aws_network_interface" "my_eni" {
#   subnet_id = aws_instance.private
# }

resource "aws_instance" "bostion" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key

  subnet_id = aws_subnet.pub-1a.id

  security_groups = [aws_security_group.worker_node_sg.id]


  tags = {
    "Name" = "Bostion host"
  }
}

resource "aws_instance" "private" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key

  subnet_id = aws_subnet.pri-1a.id

  security_groups = [aws_security_group.worker_node_sg.id]


  tags = {
    "Name" = "Private"
  }
}

output "public_instance_ip" {
  value = aws_instance.bostion.public_ip
}

output "private_instance_ip" {
  value = aws_instance.private.private_ip
}