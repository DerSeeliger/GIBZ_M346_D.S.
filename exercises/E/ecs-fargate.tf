# E-1-I: Container compute — ECS Fargate (serverless containers, no EC2 to manage)

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}-${var.student_name}"
  retention_in_days = 7
  tags              = { Owner = var.student_name }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster-${var.student_name}"
  tags = { Name = "${var.project_name}-cluster-${var.student_name}", Owner = var.student_name }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.project_name}-task-${var.student_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = data.aws_iam_role.exec.arn

  container_definitions = jsonencode([{
    name  = "nginx"
    image = "nginx:alpine"

    portMappings = [{ containerPort = 80, protocol = "tcp" }]

    command = [
      "/bin/sh", "-c",
      "printf '<!DOCTYPE html><html><head><title>M346 Container</title><style>body{font-family:sans-serif;max-width:600px;margin:50px auto;padding:20px;background:#f5f5f5}h1{color:#232f3e}.info{background:white;padding:20px;border-radius:8px;border-left:4px solid #0073bb}.tag{display:inline-block;background:#0073bb;color:white;padding:2px 8px;border-radius:4px;font-size:.8em}</style></head><body><h1>M346 Cloud Project <span class=\"tag\">Container</span></h1><div class=\"info\"><p><strong>Student:</strong> ${var.student_name}</p><p><strong>Service:</strong> Amazon ECS Fargate</p><p><strong>Compute type:</strong> Serverless Container</p><p><strong>Container image:</strong> nginx:alpine</p><p><strong>CPU:</strong> 0.25 vCPU | <strong>Memory:</strong> 512 MB</p></div></body></html>' > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.project_name}-${var.student_name}"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  tags = { Owner = var.student_name }
}

resource "aws_ecs_service" "web" {
  name            = "${var.project_name}-service-${var.student_name}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  tags = { Owner = var.student_name }
}
