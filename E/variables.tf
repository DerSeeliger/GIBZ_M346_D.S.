variable "project_name" {}
variable "student_name" {}
variable "aws_region"   {}
variable "vpc_id"       {}
variable "ami_id"       {}

variable "subnet_ids" {
  type = list(string)
}
