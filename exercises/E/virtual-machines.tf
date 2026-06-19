# E-1-B: Web server A — first AZ, Nginx, t2.micro (free tier)
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

# Web server B — second AZ, pairs with web-a behind a load balancer (see H exercise)
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
