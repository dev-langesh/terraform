resource "aws_lambda_function" "send_email_lambda" {
  function_name = "send_email_to_iam_users"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"  # Replace with your desired runtime
  filename      = "send_email_lambda.zip"
  timeout = 900

  environment {
    variables = {
      EMAIL = "langesh705@gmail.com"
      APP_PASSWORD = "rqlyhpmlftxcjaum"
    }
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_dlq.arn
  }
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_dir  = "/home/langesh/Projects/terraform/send_email_lambda"  # Path to the directory containing your Lambda code files
  output_path = "send_email_lambda.zip"
}

