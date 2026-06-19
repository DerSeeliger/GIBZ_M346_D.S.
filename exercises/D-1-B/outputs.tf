output "instance_public_ip" { value = aws_instance.web.public_ip }

output "ssh_command" {
  value = "ssh -i m346-key.pem ec2-user@${aws_instance.web.public_ip}"
}

output "s3_bucket_name"             { value = aws_s3_bucket.storage.id }
output "s3_bucket_arn"              { value = aws_s3_bucket.storage.arn }
output "ebs_volume_id"              { value = aws_ebs_volume.data.id }
output "ebs_device_name"            { value = aws_volume_attachment.data.device_name }
output "s3_verification_key"        { value = aws_s3_object.verification.key }
output "s3_verification_version_id" { value = aws_s3_object.verification.version_id }
