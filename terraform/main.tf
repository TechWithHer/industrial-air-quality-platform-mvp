#########################################
# S3 Raw Bucket
#########################################

resource "aws_s3_bucket" "raw" {
  bucket = var.raw_bucket_name
}

#########################################
# S3 Processed Bucket
#########################################

resource "aws_s3_bucket" "processed" {
  bucket = var.processed_bucket_name
}

#########################################
# S3 Athena Results Bucket
#########################################

resource "aws_s3_bucket" "athena_results" {
  bucket = var.athena_results_bucket_name
}

resource "aws_s3_bucket_versioning" "raw" {

  bucket = aws_s3_bucket.raw.id

  versioning_configuration {

    status = "Enabled"

  }

}

resource "aws_s3_bucket_versioning" "processed" {

  bucket = aws_s3_bucket.processed.id

  versioning_configuration {

    status = "Enabled"

  }

}

resource "aws_s3_bucket_versioning" "athena" {

  bucket = aws_s3_bucket.athena_results.id

  versioning_configuration {

    status = "Enabled"

  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "raw" {

  bucket = aws_s3_bucket.raw.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}
resource "aws_s3_bucket_server_side_encryption_configuration" "processed" {

  bucket = aws_s3_bucket.raw.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "athena" {

  bucket = aws_s3_bucket.raw.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"

    }

  }

}

resource "aws_s3_bucket_public_access_block" "raw" {

  bucket = aws_s3_bucket.raw.id

  block_public_acls       = true

  ignore_public_acls      = true

  block_public_policy     = true

  restrict_public_buckets = true

}

resource "aws_s3_bucket_public_access_block" "processed" {

  bucket = aws_s3_bucket.raw.id

  block_public_acls       = true

  ignore_public_acls      = true

  block_public_policy     = true

  restrict_public_buckets = true

}

resource "aws_s3_bucket_public_access_block" "athena" {

  bucket = aws_s3_bucket.raw.id

  block_public_acls       = true

  ignore_public_acls      = true

  block_public_policy     = true

  restrict_public_buckets = true

}
