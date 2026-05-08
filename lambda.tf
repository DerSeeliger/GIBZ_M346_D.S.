# Shared execution role — Academy provides LabRole with broad permissions
data "aws_iam_role" "exec" {
  name = "LabRole"
}

# Zip the Python function for upload
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# E-1-I: Serverless compute — Lambda function (Python 3.12)
resource "aws_lambda_function" "hello" {
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  function_name    = "${var.project_name}-hello-${var.student_name}"
  role             = data.aws_iam_role.exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"

  tags = { Name = "${var.project_name}-lambda-${var.student_name}", Owner = var.student_name }
}

# HTTP API Gateway — public URL trigger for the Lambda
resource "aws_apigatewayv2_api" "lambda" {
  name          = "${var.project_name}-api-${var.student_name}"
  protocol_type = "HTTP"
  tags          = { Owner = var.student_name }
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id      = aws_apigatewayv2_api.lambda.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.lambda.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.hello.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "lambda" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# Allow API Gateway to invoke the Lambda
resource "aws_lambda_permission" "apigw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
