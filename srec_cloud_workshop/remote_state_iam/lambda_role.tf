resource "aws_iam_role" "lambda_role" {
  name = "send_email_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sqs_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"  # Replace with appropriate SQS policy ARN
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"   # Replace with appropriate S3 policy ARN
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"   # Replace with appropriate S3 policy ARN
  role       = aws_iam_role.lambda_role.name
}
