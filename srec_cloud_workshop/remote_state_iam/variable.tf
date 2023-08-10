variable "region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  default = "langesh-terraform-state"
}

variable "lambda_env" {
  default = {
    EMAIL = "langesh705@gmail.com"
    APP_PASSWORD = "rqlyhpmlftxcjaum"
  }
}