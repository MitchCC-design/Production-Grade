variable "assets_bucket_name" {
  description = "The name of the S3 bucket for assets"
  type        = string
}

resource "aws_kms_key" "s3" {
  description = "KMS key for S3 bucket"
}

resource "aws_s3_bucket" "assets" {
  bucket            = var.assets_bucket_name
  

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3.arn
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = { Name = "assets-bucket" }
}

resource "aws_s3_bucket_policy" "assets_policy" {
  bucket = aws_s3_bucket.assets.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = "${aws_s3_bucket.assets.arn}/*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}