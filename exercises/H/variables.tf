variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "m346-h"
}

variable "student_name" {
  default = "david-seeliger"
}

variable "create_backup" {
  description = "Set false to skip AWS Backup resources and save budget"
  type        = bool
  default     = true
}
