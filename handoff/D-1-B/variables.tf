variable "aws_region" {
  description = "AWS region (Academy is locked to us-east-1)"
  default     = "us-east-1"
}

variable "student_name" {
  description = "Your name — used in resource names and tags"
  default     = "david-seeliger"
}

variable "project_name" {
  description = "Short prefix for all resource names"
  default     = "m346"
}

variable "create_backup" {
  description = "Set false to skip AWS Backup resources and save budget"
  type        = bool
  default     = true
}
