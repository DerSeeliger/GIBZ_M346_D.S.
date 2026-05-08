# AWS Backup plan — uses Academy's pre-existing LabRole
data "aws_iam_role" "lab_role" {
  count = var.create_backup ? 1 : 0
  name  = "LabRole"
}

resource "aws_backup_vault" "main" {
  count = var.create_backup ? 1 : 0
  name  = "${var.project_name}-backup-vault"
  tags  = { Owner = var.student_name }
}

resource "aws_backup_plan" "main" {
  count = var.create_backup ? 1 : 0
  name  = "${var.project_name}-backup-plan"

  rule {
    rule_name         = "daily-backup-7day-retention"
    target_vault_name = aws_backup_vault.main[0].name
    schedule          = "cron(0 2 * * ? *)"  # daily at 02:00 UTC

    lifecycle {
      delete_after = 7
    }
  }

  tags = { Owner = var.student_name }
}

# Tag-based assignment: backs up anything tagged Backup=true
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
