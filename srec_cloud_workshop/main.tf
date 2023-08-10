resource "aws_iam_user" "iam_users" {
  name = each.value
  for_each = var.users
}

resource "aws_iam_user_login_profile" "iam_user_passwords" {
  password_length = 8
  password_reset_required = true
  user = aws_iam_user.iam_users[each.value].name
  for_each = var.users

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_iam_group" "srec" {
  name = "SREC"
}

resource "aws_iam_group_policy_attachment" "policy_attachment" {
  policy_arn = "arn:aws:iam::686355966270:policy/ec2-srec"
  group = aws_iam_group.srec.name
}

resource "aws_iam_group_membership" "srec_students_membership" {
  name = "srec_students"
  group = aws_iam_group.srec.name
  users = [each.value.name]
  for_each = aws_iam_user.iam_users
}
