variable "region" {
  default = "ap-south-1"
}

variable "users" {
  type = set(string)
  default = ["dev.langesh@gmail.com","langesh.2101131@srec.ac.in","abhivandan.2101002@srec.ac.in"]
}

