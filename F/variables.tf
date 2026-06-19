variable "project_name" {}
variable "student_name" {}
variable "ami_id" {}
variable "key_name" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "my_ip_cidr" {
  description = "Your home/office public IP, for bastion SSH access. Update if it changes between sessions."
  default     = "83.78.9.159/32"
}

variable "db_username" {
  default = "admin"
}
