data "archive_file" "transformer_zip" {

  type        = "zip"
  source_dir  = "../lambdas/transformer"
  output_path = "../lambdas/transformer.zip"

}

data "aws_iam_policy_document" "transformer_policy" {

  statement {

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]

  }

  statement {

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.raw.arn}/*"
    ]

  }

  statement {

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.processed.arn}/*"
    ]

  }

}

resource "aws_iam_policy" "transformer_policy" {

  name   = "iaqap-dev-transformer-policy"
  policy = data.aws_iam_policy_document.transformer_policy.json

}

resource "aws_iam_role" "transformer_lambda_role" {

  name = "iaqap-dev-transformer-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

}

resource "aws_iam_role_policy_attachment" "transformer_policy_attachment" {

  role       = aws_iam_role.transformer_lambda_role.name

  policy_arn = aws_iam_policy.transformer_policy.arn

}
resource "aws_lambda_function" "transformer" {

  function_name = "iaqap-dev-transformer"

  filename         = data.archive_file.transformer_zip.output_path
  source_code_hash = data.archive_file.transformer_zip.output_base64sha256

  role    = aws_iam_role.transformer_lambda_role.arn
  handler = "app.lambda_handler"

  runtime = "python3.11"

  timeout = 30

  environment {

    variables = {

      PROCESSED_BUCKET = aws_s3_bucket.processed.bucket

    }

  }

}

resource "aws_cloudwatch_log_group" "transformer" {

  name = "/aws/lambda/iaqap-dev-transformer"

  retention_in_days = 14

}

resource "aws_lambda_permission" "allow_s3" {

  statement_id = "AllowExecutionFromS3"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.transformer.function_name

  principal = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.raw.arn

}

resource "aws_s3_bucket_notification" "raw_notification" {

  bucket = aws_s3_bucket.raw.id

  lambda_function {

    lambda_function_arn = aws_lambda_function.transformer.arn

    events = [
      "s3:ObjectCreated:*"
    ]

  }

  depends_on = [

    aws_lambda_permission.allow_s3

  ]

}