variable "region" {
  default = "ap-south-1"
}

variable "users" {
  type = set(string)
  # default = []
  default = ["dev.langesh@gmail.com","aws.langesh@gmail.com","langesh705@gmail.com","langesh105@gmail.com","langesh.2101131@srec.ac.in"]
}

