# D-1-B — Storage Services: S3 (Object) + EBS (Block)

# ── Object Storage: S3 ──────────────────────────────────────────────────────

resource "aws_s3_bucket" "storage" {
  bucket        = "${var.project_name}-storage-${var.student_name}"
  force_destroy = true

  tags = {
    Name  = "${var.project_name}-storage"
    Owner = var.student_name
  }
}

resource "aws_s3_bucket_versioning" "storage" {
  bucket = aws_s3_bucket.storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "storage" {
  bucket                  = aws_s3_bucket.storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "storage" {
  bucket = aws_s3_bucket.storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Verification object — uploaded as v1, then overwritten with v2 content to
# demonstrate S3 versioning is actually enabled and working.
resource "aws_s3_object" "verification" {
  bucket       = aws_s3_bucket.storage.id
  key          = "d1b-verification.txt"
  content_type = "text/plain"
  content      = file("${path.module}/${var.verification_object_version}")

  tags = { Owner = var.student_name }
}

# ── Block Storage: EBS ──────────────────────────────────────────────────────

resource "aws_ebs_volume" "data" {
  availability_zone = aws_instance.web.availability_zone
  size              = 10
  type              = "gp3"

  tags = {
    Name  = "${var.project_name}-ebs-data-${var.student_name}"
    Owner = var.student_name
  }
}

resource "aws_volume_attachment" "data" {
  device_name  = "/dev/xvdf"
  volume_id    = aws_ebs_volume.data.id
  instance_id  = aws_instance.web.id
  force_detach = true
}
