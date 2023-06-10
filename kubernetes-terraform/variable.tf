variable "region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key" {
  default = "aws_key"
}

variable "ebs_az" {
  default = "ap-south-1a"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_pub_1a_cidr" {
  default = "10.0.1.0/24"
}

variable "subnet_pub_2b_cidr" {
  default = "10.0.10.0/24"
}