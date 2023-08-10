resource "aws_sqs_queue" "lambda_dlq" {
  name = "lambda_dlq"
  
}