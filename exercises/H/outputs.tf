output "alb_url"        { value = "http://${aws_lb.web.dns_name}" }
output "s3_bucket_name" { value = aws_s3_bucket.backup.bucket }
output "s3_backup_html" { value = "s3://${aws_s3_bucket.backup.bucket}/${aws_s3_object.test_data.key}" }

output "web_a_public_ip" { value = aws_instance.web_a.public_ip }
output "web_b_public_ip" { value = aws_instance.web_b.public_ip }

output "ssh_command_a" {
  value = "ssh -i m346-key.pem ec2-user@${aws_instance.web_a.public_ip}"
}
output "ssh_command_b" {
  value = "ssh -i m346-key.pem ec2-user@${aws_instance.web_b.public_ip}"
}
