# E-1-B: SSH key pair — RSA 4096, private key written to this folder on apply
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key-${var.student_name}"
  public_key = tls_private_key.main.public_key_openssh
  tags       = { Name = "${var.project_name}-keypair", Owner = var.student_name }
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.main.private_key_pem
  filename        = "${path.root}/m346-key.pem"
  file_permission = "0600"
}
