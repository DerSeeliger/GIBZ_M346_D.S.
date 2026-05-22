terraform {
  required_providers {
    aws     = { source = "hashicorp/aws",     version = "~> 5.0" }
    tls     = { source = "hashicorp/tls",     version = "~> 4.0" }
    local   = { source = "hashicorp/local",   version = "~> 2.0" }
    archive = { source = "hashicorp/archive", version = "~> 2.0" }
  }

  backend "local" {
    path = "tfstate/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

# Shared data sources — passed into modules as variables
data "aws_vpc" "default" { default = true }

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "defaultForAz"
    values = ["true"]
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# K05 — Compute Services (E-1-B: EC2  |  E-1-I: Lambda, ECS)
module "E" {
  source       = "./E"
  project_name = var.project_name
  student_name = var.student_name
  aws_region   = var.aws_region
  vpc_id       = data.aws_vpc.default.id
  subnet_ids   = data.aws_subnets.default.ids
  ami_id       = data.aws_ami.amazon_linux_2023.id
}

# K08 — Data Security (H-1: Backup, ALB, S3 versioning)
module "H" {
  source            = "./H"
  project_name      = var.project_name
  student_name      = var.student_name
  vpc_id            = data.aws_vpc.default.id
  subnet_ids        = data.aws_subnets.default.ids
  web_a_instance_id = module.E.web_a_instance_id
  web_b_instance_id = module.E.web_b_instance_id
  create_backup     = var.create_backup
}
