# H-1: AWS Backup plan — daily EBS/EC2 backups, 7-day retention, tag-based scope.
# Uses AWS Academy's pre-provisioned "LabRole" — outside Academy, swap for a
# purpose-built IAM role with backup permissions.
data "aws_iam_role" "lab_role" {
  count = var.create_backup ? 1 : 0
  name  = "LabRole"
}

resource "aws_backup_vault" "main" {
  count         = var.create_backup ? 1 : 0
  name          = "${var.project_name}-backup-vault"
  force_destroy = true
  tags          = { Owner = var.student_name }
}

resource "aws_backup_plan" "main" {
  count = var.create_backup ? 1 : 0
  name  = "${var.project_name}-backup-plan"

  rule {
    rule_name         = "daily-backup-7day-retention"
    target_vault_name = aws_backup_vault.main[0].name
    schedule          = "cron(0 2 * * ? *)"

    lifecycle {
      delete_after = 7
    }
  }

  tags = { Owner = var.student_name }
}

# Backs up all resources tagged Backup=true (both web servers)
resource "aws_backup_selection" "main" {
  count        = var.create_backup ? 1 : 0
  name         = "${var.project_name}-backup-selection"
  plan_id      = aws_backup_plan.main[0].id
  iam_role_arn = data.aws_iam_role.lab_role[0].arn

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}
