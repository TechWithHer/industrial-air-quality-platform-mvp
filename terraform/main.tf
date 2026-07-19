#########################################
# S3 Raw Bucket
#########################################

resource "aws_s3_bucket" "raw" {
  bucket = var.raw_bucket_name
}

# Access Block ############################
resource "aws_s3_bucket_public_access_block" "raw" {

  bucket = aws_s3_bucket.raw.id

  block_public_acls = true

  ignore_public_acls = true

  block_public_policy = true

  restrict_public_buckets = true

}

# Versioning ###############################

resource "aws_s3_bucket_versioning" "raw" {

  bucket = aws_s3_bucket.raw.id

  versioning_configuration {

    status = "Enabled"

  }

}

# ENCRYPTION #################################

resource "aws_s3_bucket_server_side_encryption_configuration" "raw" {

  bucket = aws_s3_bucket.raw.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

#########################################
# S3 Processed Bucket
#########################################

resource "aws_s3_bucket" "processed" {
  bucket = var.processed_bucket_name
}

# Access Block ############################

resource "aws_s3_bucket_public_access_block" "processed" {

  bucket = aws_s3_bucket.processed.id

  block_public_acls = true

  ignore_public_acls = true

  block_public_policy = true

  restrict_public_buckets = true

}

# Versioning ###############################

resource "aws_s3_bucket_versioning" "processed" {

  bucket = aws_s3_bucket.processed.id

  versioning_configuration {

    status = "Enabled"

  }

}
# ENCRYPTION #################################

resource "aws_s3_bucket_server_side_encryption_configuration" "processed" {

  bucket = aws_s3_bucket.processed.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}


#########################################
# S3 Athena Results Bucket
#########################################

resource "aws_s3_bucket" "athena_results" {
  bucket = var.athena_results_bucket_name
}

# Access Block ############################

resource "aws_s3_bucket_public_access_block" "athena_results" {

  bucket = aws_s3_bucket.athena_results.id

  block_public_acls = true

  ignore_public_acls = true

  block_public_policy = true

  restrict_public_buckets = true

}


# Versioning ###############################

resource "aws_s3_bucket_versioning" "athena_results" {

  bucket = aws_s3_bucket.athena_results.id

  versioning_configuration {

    status = "Enabled"

  }

}

# ENCRYPTION #################################

resource "aws_s3_bucket_server_side_encryption_configuration" "athena_results" {

  bucket = aws_s3_bucket.athena_results.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "collector_lambda_role" {
  name = "iaqap-dev-collector-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}
data "aws_iam_policy_document" "collector_policy" {

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.raw.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "collector_policy" {
  name   = "iaqap-dev-collector-policy"
  policy = data.aws_iam_policy_document.collector_policy.json
}
resource "aws_iam_role_policy_attachment" "collector_policy_attachment" {

  role = aws_iam_role.collector_lambda_role.name

  policy_arn = aws_iam_policy.collector_policy.arn

}
