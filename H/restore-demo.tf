# H-1-A: Initial test object in S3 — this is the "good" version to restore back to
resource "aws_s3_object" "test_data" {
  bucket  = aws_s3_bucket.backup.id
  key     = "restore-demo/test-data.txt"
  content = "M346 Backup Restore Demo\nStudent: ${var.student_name}\nVersion: ORIGINAL - this data is correct\n"

  tags = { Owner = var.student_name }
}
