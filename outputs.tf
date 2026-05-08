# E-1-B: EC2 (Virtual Machine)
output "e1b_ec2_url" {
  description = "E-1-B: Nginx on EC2 — open in browser"
  value       = "http://${aws_instance.web.public_ip}"
}

output "e1b_ssh_command" {
  description = "E-1-B: SSH into EC2"
  value       = "ssh -i ${path.module}/m346-key.pem ec2-user@${aws_instance.web.public_ip}"
}

output "e1b_instance_id" {
  value = aws_instance.web.id
}

# E-1-I: Lambda (Serverless)
output "e1i_lambda_url" {
  description = "E-1-I: Lambda via API Gateway — open in browser"
  value       = aws_apigatewayv2_stage.lambda.invoke_url
}

output "e1i_lambda_function_name" {
  value = aws_lambda_function.hello.function_name
}

# E-1-I: ECS Fargate (Container)
output "e1i_ecs_cluster" {
  value = aws_ecs_cluster.main.name
}

output "e1i_ecs_get_task_ip" {
  description = "E-1-I: Run this after apply to get the ECS task public IP"
  value       = "aws ecs list-tasks --cluster ${aws_ecs_cluster.main.name} --query 'taskArns[0]' --output text | xargs -I{} aws ecs describe-tasks --cluster ${aws_ecs_cluster.main.name} --tasks {} --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' --output text | xargs -I{} aws ec2 describe-network-interfaces --network-interface-ids {} --query 'NetworkInterfaces[0].Association.PublicIp' --output text"
}
