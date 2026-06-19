variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "m346-f1a"
}

variable "student_name" {
  default = "david-seeliger"
}

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
  description = "Your home/office public IP, for bastion SSH access. Change this to your own IP/32 before applying."
  default     = "83.78.9.159/32"
}

variable "db_username" {
  default = "admin"
}
