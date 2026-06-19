variable "project_name" {}
variable "student_name" {}
variable "web_a_instance_id" {}

variable "verification_object_version" {
  description = "Which local test-data file to upload as the S3 verification object — flip from v1 to v2 between applies to demonstrate versioning."
  default     = "test-data-v2.txt"
}
