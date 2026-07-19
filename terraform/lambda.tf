data "archive_file" "collector_zip" {
  type        = "zip"
  source_dir  = "../lambdas/collector"
  output_path = "../lambdas/collector.zip"
}

resource "aws_cloudwatch_log_group" "collector" {
  name              = "/aws/lambda/iaqap-dev-collector"
  retention_in_days = 14
}

resource "aws_lambda_function" "collector" {

  function_name = "iaqap-dev-collector"

  role = aws_iam_role.collector_lambda_role.arn

  handler = "app.lambda_handler"

  runtime = "python3.11"

  filename         = data.archive_file.collector_zip.output_path
  source_code_hash = data.archive_file.collector_zip.output_base64sha256

  timeout = 30

  memory_size = 256

  environment {

    variables = {

      RAW_BUCKET = aws_s3_bucket.raw.bucket

    }

  }

  depends_on = [
    aws_cloudwatch_log_group.collector
  ]
}
