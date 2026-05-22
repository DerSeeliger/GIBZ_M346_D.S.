# H-1-A: Backup copy of the website index.html stored in S3 — used for the restore demo
resource "aws_s3_object" "test_data" {
  bucket       = aws_s3_bucket.backup.id
  key          = "restore-demo/index.html"
  content_type = "text/html"
  content      = <<-HTML
    <!DOCTYPE html>
    <html>
    <head><title>M346 Web App</title>
    <style>body{font-family:sans-serif;max-width:600px;margin:50px auto;padding:20px;background:#f5f5f5}
    h1{color:#232f3e}.info{background:white;padding:20px;border-radius:8px;border-left:4px solid #ff9900}
    .ok{color:green;font-weight:bold}</style>
    </head>
    <body>
    <h1>M346 Cloud Project</h1>
    <div class="info">
      <p><strong>Student:</strong> ${var.student_name}</p>
      <p><strong>Status:</strong> <span class="ok">Running - restored from S3 backup</span></p>
      <p><strong>Backup source:</strong> s3://${var.project_name}-backup-${var.student_name}/restore-demo/index.html</p>
    </div>
    </body>
    </html>
  HTML

  tags = { Owner = var.student_name }
}
