resource "aws_iam_user" "iam_users" {
  name = each.value
  for_each = var.users
}

resource "aws_iam_user_login_profile" "iam_user_passwords" {
  password_length = 8
  password_reset_required = true
  user = aws_iam_user.iam_users[each.value].name
  for_each = var.users
}

resource "aws_iam_group" "srec" {
  name = "SREC"
}

resource "aws_iam_group_membership" "srec_students_membership" {
  name = "srec_students"
  group = aws_iam_group.srec.name
  users = var.users
}

resource "aws_iam_group_policy" "srec_students_policy" {
  name = "srec_students_policy"
  group = aws_iam_group.srec.name
  policy = jsonencode({
     Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "iam:*",
            "ec2:Describe*"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
  })
}

