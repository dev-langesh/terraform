terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "langesh-terraform-state"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
  }
}