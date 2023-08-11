resource "aws_dynamodb_table" "users" {
  name = "iam_users"
  hash_key = "email"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "email"
    type = "S"
  }
}