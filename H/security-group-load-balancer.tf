# H-1: Load balancer security group — HTTP in from internet, all out
resource "aws_security_group" "load_balancer" {
  name        = "${var.project_name}-sg-alb-${var.student_name}"
  description = "Application Load Balancer — HTTP from internet"
  vpc_id      = var.vpc_id

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
