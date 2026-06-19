variable "aws_region" {
  description = "AWS region (note: this project was built on AWS Academy, which is locked to us-east-1)"
  default     = "us-east-1"
}

variable "student_name" {
  description = "Your name — used in resource names and tags"
  default     = "david-seeliger"
}

variable "project_name" {
  description = "Short prefix for all resource names"
  default     = "m346-e"
}
