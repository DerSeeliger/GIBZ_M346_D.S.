# H-1 needs two web servers to put behind the ALB — the original build reused
# the pair from the E exercise; this standalone copy creates its own instead.

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

resource "aws_instance" "web_a" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true
  user_data                   = base64encode(file("${path.module}/ec2-userdata.sh"))

  tags = {
    Name   = "${var.project_name}-web-a-${var.student_name}"
    Owner  = var.student_name
    Backup = "true"
  }
}

resource "aws_instance" "web_b" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnets.default.ids[1]
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true
  user_data                   = base64encode(file("${path.module}/ec2-userdata.sh"))

  tags = {
    Name   = "${var.project_name}-web-b-${var.student_name}"
    Owner  = var.student_name
    Backup = "true"
  }
}
