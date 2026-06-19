# Minimal EC2 instance — D-1-B only needs something to mount the EBS volume on.
resource "aws_security_group" "ssh" {
  name        = "${var.project_name}-sg-ssh-${var.student_name}"
  description = "SSH access only"
  vpc_id      = data.aws_vpc.default.id

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

  tags = { Name = "${var.project_name}-sg-ssh", Owner = var.student_name }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true

  tags = {
    Name  = "${var.project_name}-web-${var.student_name}"
    Owner = var.student_name
  }
}
