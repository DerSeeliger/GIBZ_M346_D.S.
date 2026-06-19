# F-1-A / I-1-A — Security groups: each tier only accepts traffic from the tier in front of it.

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-sg-alb-${var.student_name}"
  description = "ALB - HTTP from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-alb", Owner = var.student_name }
}

resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-sg-bastion-${var.student_name}"
  description = "Bastion host - SSH from admin IP only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
    description = "SSH from admin IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-bastion", Owner = var.student_name }
}

resource "aws_security_group" "nat" {
  name        = "${var.project_name}-sg-nat-${var.student_name}"
  description = "NAT instance - all traffic from VPC CIDR only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "All traffic from inside the VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-nat", Owner = var.student_name }
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-sg-web-private-${var.student_name}"
  description = "Web tier (private subnet) - HTTP from ALB only, SSH from bastion only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "HTTP from ALB"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
    description     = "SSH from bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-web-private", Owner = var.student_name }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-sg-rds-${var.student_name}"
  description = "RDS - MySQL from web tier only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id, aws_security_group.bastion.id]
    description     = "MySQL from web tier and bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-rds", Owner = var.student_name }
}
