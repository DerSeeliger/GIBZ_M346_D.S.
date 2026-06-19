output "key_name"          { value = aws_key_pair.main.key_name }
output "web_a_instance_id" { value = aws_instance.web_a.id }
output "web_b_instance_id" { value = aws_instance.web_b.id }
output "web_a_public_ip"   { value = aws_instance.web_a.public_ip }

output "ssh_command" {
  value = "ssh -i m346-key.pem ec2-user@${aws_instance.web_a.public_ip}"
}

output "lambda_url"           { value = aws_apigatewayv2_stage.lambda.invoke_url }
output "lambda_function_name" { value = aws_lambda_function.hello.function_name }
output "ecs_cluster_name"     { value = aws_ecs_cluster.main.name }
