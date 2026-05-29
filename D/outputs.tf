output "s3_bucket_name" {
  value = aws_s3_bucket.storage.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.storage.arn
}

output "ebs_volume_id" {
  value = aws_ebs_volume.data.id
}

output "ebs_device_name" {
  value = aws_volume_attachment.data.device_name
}
