terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_sns_topic" "fanout_sns" {
    name = "fanout"
}

data "aws_iam_policy_document" "sqs-queue-policy" {

  statement {
    sid    = "example-sns-topic"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "sqs:*",
    ]

    resources = ["*"]

    condition {
     test = "ArnEquals"
     variable = "aws:SourceArn"
     values = [aws_sns_topic.fanout_sns.arn]
    }
  }
}

resource "aws_sqs_queue" "sqs_q1" {
  name = "fanout_q1"

  visibility_timeout_seconds = 10

  policy = data.aws_iam_policy_document.sqs-queue-policy.json

#   tags = {
#     "Name" = "fanout_q1" 
#   }
}

resource "aws_sqs_queue" "sqs_q2" {
  name = "fanout_q2"

  visibility_timeout_seconds = 10

  policy = data.aws_iam_policy_document.sqs-queue-policy.json


#   policy = 


#   tags = {
#     "Name" = "fanout_q2" 
#   }
}

resource "aws_sns_topic_subscription" "q1_sub" {
  topic_arn = aws_sns_topic.fanout_sns.arn

  endpoint = aws_sqs_queue.sqs_q1.arn

  protocol = "sqs"

  depends_on = [ aws_sns_topic.fanout_sns ]
}

resource "aws_sns_topic_subscription" "q2_sub" {
  topic_arn = aws_sns_topic.fanout_sns.arn

  endpoint = aws_sqs_queue.sqs_q2.arn

  protocol = "sqs"

  depends_on = [ aws_sns_topic.fanout_sns ]
}