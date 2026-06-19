# M346 — per-exercise Terraform

Each folder below is a **standalone** Terraform root for one M346 competency — `cd` into
a folder and `terraform init && terraform apply` just works, with no dependency on any
other folder. That's deliberate: the live project at `project/terraform/` wires every
competency together as modules of one deployment (cheaper, since e.g. D/F/H all reuse the
same EC2 instances/key pair), but that means no single competency's code can be copied out
and run in isolation. These folders trade a bit of resource duplication (each one creates
its own key pair, and D/E/H each create their own EC2 instance(s)) for being copy-paste-able.

Screenshots are intentionally not included here — just the Terraform, the userdata/scripts,
and the written doc/report for each competency (which also lists what was screenshotted,
for reference).

## Prerequisites

- An AWS account with credentials available to the AWS provider (env vars, `~/.aws/credentials`, or AWS Academy Learner Lab session credentials)
- Terraform >= 1.5, AWS provider `~> 5.0`
- `E/`, `H/` use AWS Academy's pre-provisioned `LabRole` for Lambda/ECS/Backup execution roles — outside an Academy Learner Lab, create an equivalent IAM role and update the `data "aws_iam_role"` lookups
- `F-1-A/`, `I-1-A/` bastion security group only allows SSH from `var.my_ip_cidr` — override this with your own public IP before applying

## Running one

```
cd D-1-B
terraform init
terraform apply
```

Each folder generates its own SSH key pair on apply (`m346-key.pem`, written into that
folder, gitignored) and `F-1-A`/`I-1-A` also generate `db-password.txt` (RDS password,
gitignored). Don't commit either.

Resource names are prefixed with `var.project_name`, which defaults to a distinct value
per folder (e.g. `m346-d1b`, `m346-f1a`) — safe to `apply` more than one of these folders
in the same AWS account at once without name collisions. Override `student_name` (and
`project_name` if you want your own prefix) via `-var` or a `terraform.tfvars` file.

## Folders

| Folder | Competency | Contents |
|---|---|---|
| `C-1-A/` | Cost optimization report | `report.md` + `costs-comparison.csv` — no Terraform (pure cost calculation) |
| `C-1-B/` | Cost calc, 2 individual services | `doc.md` + `costs.csv` — no Terraform |
| `C-1-I/` | Cost calc, real infrastructure | `doc.md` + `costs.csv` — no Terraform |
| `D-1-B/` | Storage services (S3 + EBS) | Terraform + `doc.md` |
| `E/` | Compute services (EC2, Lambda, ECS Fargate) | Terraform only (submitted via video before written docs were required) |
| `F-1-A/` | Network architecture (HA VPC, ALB+ASG, RDS Multi-AZ) | Terraform + `doc.md` + `diagram.md` |
| `H/` | Data security (AWS Backup, ALB, restore demo) | Terraform + `restore-demo-commands.txt` (no doc.md — submitted via video) |
| `I-1-A/` | Operational architecture | Same infrastructure as `F-1-A` (separate full copy) + `discussion-prep.md` |

`F-1-A` and `I-1-A` are two folders describing the same architecture for two different
competencies — not a typo, see each folder's doc for why.
