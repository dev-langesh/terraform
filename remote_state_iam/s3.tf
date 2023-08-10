resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = var.bucket_name
}


resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.terraform-state-bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "example_lifecycle" {
  rule {
    id      = "expire-noncurrent-versions"
    status  = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }

  bucket = aws_s3_bucket.terraform-state-bucket.id
}

resource "aws_s3_bucket_notification" "example_bucket_notification" {
  bucket = aws_s3_bucket.terraform-state-bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.send_email_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".tfstate"  # Optional: Add a suffix filter for specific file types
  }

  depends_on = [ aws_lambda_permission.allow_bucket ]

}