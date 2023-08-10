variable "region" {
  default = "ap-south-1"
}

variable "users" {
  type = set(string)
  default = [ "dev.langesh@gmail.com"]
}

