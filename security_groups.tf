# E-1-B: Web server security group
# Port 80: HTTP from internet (verify Nginx works)
# Port 22: SSH from internet (access permissions demo)
resource "aws_security_group" "web" {
  name        = "${var.project_name}-sg-web-${var.student_name}"
  description = "Web server - HTTP and SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from internet"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH from internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-sg-web", Owner = var.student_name }
}

# E-1-I: ECS Fargate security group — HTTP in, all out
resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-sg-ecs-${var.student_name}"
  description = "ECS Fargate tasks - HTTP access"
  vpc_id      = data.aws_vpc.default.id

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

  tags = { Name = "${var.project_name}-sg-ecs", Owner = var.student_name }
}
