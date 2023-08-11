resource "aws_lambda_function" "send_email_lambda" {
  function_name = "send_email_to_iam_users"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"  # Replace with your desired runtime
  filename      = "send_email_lambda.zip"
  timeout = 900

  environment {
    variables = {
      EMAIL = var.lambda_env.EMAIL
      APP_PASSWORD = var.lambda_env.APP_PASSWORD
    }
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_dlq.arn
  }
}

resource "aws_sqs_queue" "lambda_dlq" {
  name = "lambda_dlq"
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_dir  = "../extract_users_lambda"  # Path to the directory containing your Lambda code files
  output_path = "send_email_lambda.zip"
}

