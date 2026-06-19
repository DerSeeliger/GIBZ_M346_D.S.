# F-1-A / I-1-A — Web tier: ALB in public subnets + Auto Scaling Group across
# private subnets in 2 AZs. Bastion host for SSH access into the private tier.

resource "aws_lb" "web" {
  name               = "${var.project_name}-alb-ha-${var.student_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  tags = { Name = "${var.project_name}-alb-ha", Owner = var.student_name }
}

resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-tg-ha-${var.student_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
  }

  tags = { Name = "${var.project_name}-tg-ha", Owner = var.student_name }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-lt-web-"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.web.id]
  }

  user_data = base64encode(file("${path.module}/web-userdata.sh"))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "${var.project_name}-web-asg-${var.student_name}", Owner = var.student_name }
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "${var.project_name}-asg-web-${var.student_name}"
  vpc_zone_identifier = aws_subnet.private[*].id
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-web-asg-${var.student_name}"
    propagate_at_launch = true
  }
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public[1].id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = file("${path.module}/bastion-userdata.sh")

  tags = { Name = "${var.project_name}-bastion-${var.student_name}", Owner = var.student_name }
}
