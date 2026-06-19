# F-1-A / I-1-A — HA database: RDS MySQL, Multi-AZ, private subnets only.

resource "random_password" "db" {
  length  = 20
  special = false
}

resource "local_sensitive_file" "db_password" {
  content  = random_password.db.result
  filename = "${path.root}/db-password.txt"
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group-${var.student_name}"
  subnet_ids = aws_subnet.private[*].id

  tags = { Name = "${var.project_name}-db-subnet-group", Owner = var.student_name }
}

resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-db-${var.student_name}"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "m346db"
  username               = var.db_username
  password               = random_password.db.result
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = { Name = "${var.project_name}-db-ha", Owner = var.student_name }
}
