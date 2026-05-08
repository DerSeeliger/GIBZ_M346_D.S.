variable "aws_region" {
  description = "AWS region (Academy is locked to us-east-1 or us-west-2)"
  default     = "us-east-1"
}

variable "student_name" {
  description = "Your name — used in resource names and tags so screenshots show it's yours"
  default     = "david-seeliger"
}

variable "project_name" {
  description = "Short prefix for all resource names"
  default     = "m346"
}

variable "db_password" {
  description = "RDS master password"
  sensitive   = true
  default     = "M346Gibz2024!"
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ for RDS. Set true only for the H-1-A failover demo to save cost."
  type        = bool
  default     = false
}

variable "create_rds" {
  description = "Whether to create the RDS instance. Set false to save budget."
  type        = bool
  default     = true
}

variable "create_backup" {
  description = "Whether to create AWS Backup plan"
  type        = bool
  default     = true
}
