# E-1-I: ECS Fargate security group — HTTP in, all out
resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-sg-ecs-${var.student_name}"
  description = "ECS Fargate tasks — HTTP access"
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

  tags = { Name = "${var.project_name}-sg-ecs", Owner = var.student_name }
}
