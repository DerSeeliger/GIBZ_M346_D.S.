output "vpc_id"             { value = aws_vpc.main.id }
output "public_subnet_ids"  { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }

output "nat_instance_id"        { value = aws_instance.nat.id }
output "nat_instance_public_ip" { value = aws_instance.nat.public_ip }

output "bastion_public_ip" { value = aws_instance.bastion.public_ip }
output "bastion_ssh_command" {
  value = "ssh -i m346-key.pem ec2-user@${aws_instance.bastion.public_ip}"
}

output "alb_dns_name" { value = aws_lb.web.dns_name }
output "alb_url"      { value = "http://${aws_lb.web.dns_name}" }
output "asg_name"     { value = aws_autoscaling_group.web.name }

output "rds_endpoint" { value = aws_db_instance.main.endpoint }
output "rds_db_name"  { value = aws_db_instance.main.db_name }
output "rds_username" { value = aws_db_instance.main.username }
