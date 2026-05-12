# H-1: S3 bucket — versioning enabled for object-level restore demo
resource "aws_s3_bucket" "backup" {
  bucket        = "${var.project_name}-backup-${var.student_name}"
  force_destroy = true

  tags = {
    Name  = "${var.project_name}-backup"
    Owner = var.student_name
  }
}

resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
