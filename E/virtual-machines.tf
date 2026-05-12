# E-1-B: Web server A — first AZ, Nginx, t2.micro (free tier)
resource "aws_instance" "web_a" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_ids[0]
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

# H-1: Web server B — second AZ, pairs with web-a behind the load balancer
resource "aws_instance" "web_b" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_ids[1]
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
