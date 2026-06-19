# ── K05 E-1-B: EC2 ────────────────────────────────────────────────────────────
output "e1b_ec2_url" {
  description = "Nginx on EC2-a — open in browser"
  value       = "http://${module.E.web_a_public_ip}"
}

output "e1b_ssh_command" {
  description = "SSH into EC2-a"
  value       = module.E.ssh_command
}

output "e1b_instance_id_a" { value = module.E.web_a_instance_id }
output "e1b_instance_id_b" { value = module.E.web_b_instance_id }

# ── K05 E-1-I: Lambda + ECS ───────────────────────────────────────────────────
output "e1i_lambda_url" {
  description = "Lambda via API Gateway — open in browser"
  value       = module.E.lambda_url
}

output "e1i_lambda_function_name" { value = module.E.lambda_function_name }
output "e1i_ecs_cluster"          { value = module.E.ecs_cluster_name }

# ── K08 H-1: Backup + HA ──────────────────────────────────────────────────────
output "h1_alb_url" {
  description = "ALB URL — refresh to see both AZs responding (HA demo)"
  value       = module.H.alb_url
}

output "h1_s3_bucket" {
  description = "S3 bucket with versioning enabled"
  value       = module.H.s3_bucket_name
}

# ── K06/K09 F-1-A / I-1-A: HA network + operational architecture ──────────────
output "f1a_alb_url"        { value = module.F.alb_url }
output "f1a_asg_name"       { value = module.F.asg_name }
output "f1a_vpc_id"         { value = module.F.vpc_id }
output "f1a_rds_endpoint"   { value = module.F.rds_endpoint }
output "f1a_rds_username"   { value = module.F.rds_username }
output "f1a_nat_public_ip"  { value = module.F.nat_instance_public_ip }
output "f1a_bastion_ip"     { value = module.F.bastion_public_ip }
output "f1a_bastion_ssh"    { value = module.F.bastion_ssh_command }
