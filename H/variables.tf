variable "project_name" {}
variable "student_name" {}
variable "vpc_id"            {}
variable "web_a_instance_id" {}
variable "web_b_instance_id" {}

variable "subnet_ids" {
  type = list(string)
}

variable "create_backup" {
  type    = bool
  default = true
}
