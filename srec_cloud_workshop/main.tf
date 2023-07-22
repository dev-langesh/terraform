resource "aws_iam_user" "iam_users" {
  name = each.value
  for_each = var.users
}