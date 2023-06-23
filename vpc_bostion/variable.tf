variable "aws_vpc_cidr" {
  default = "10.0.0.0/16"
}

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
  default = "dever_keyk"
}

variable "ebs_az" {
  default = "ap-south-1a"
}