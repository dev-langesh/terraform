output "public_ip" {
  description = "public ip"
  value = aws_instance.ubuntu.public_ip
}