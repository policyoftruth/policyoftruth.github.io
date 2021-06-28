resource "aws_kms_key" "kopskey" {
  description             = "kops bucket key"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "s3_kops" {
  bucket = "two-states-kops"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kopskey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }
}
