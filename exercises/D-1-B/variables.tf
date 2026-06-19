variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "student_name" {
  description = "Your name — used in resource names and tags"
  default     = "david-seeliger"
}

variable "project_name" {
  description = "Short prefix for all resource names"
  default     = "m346-d1b"
}

variable "verification_object_version" {
  description = "Which local test-data file to upload as the S3 verification object — flip from v1 to v2 between applies to demonstrate versioning."
  default     = "test-data-v2.txt"
}
