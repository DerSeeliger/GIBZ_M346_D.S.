# C-1-I — Estimate costs (Intermediate)

> I can determine and operate the appropriate cloud storage service... / calculate the operating costs of a small cloud infrastructure.

## Task

Calculate the operating costs of a small cloud infrastructure — ideally the architecture from competence I. Identify all cost factors, calculate expected monthly cost for a realistic usage scenario, document assumptions, present results transparently.

## Chosen infrastructure

The real I-1-A / F-1-A architecture (`project/terraform/F/`), already live in this Academy account:

- 1× NAT instance (t2.micro)
- 1× Bastion host (t2.micro)
- Auto Scaling Group, web tier: 2 instances baseline (t2.micro), can scale to 4
- 1× Application Load Balancer
- 1× RDS MySQL, Multi-AZ, db.t3.micro, 20 GB storage
- Each EC2 instance has a 30 GB gp3 root volume (confirmed via `aws ec2 describe-volumes` — this is the AL2023 AMI's default root size, not something we set explicitly)

## Usage scenario assumptions

- All compute runs 24/7 for the full month (730 hours) — baseline ASG capacity (2 instances), not scaled up
- ALB carries light traffic: ~1 LCU average (a small number of concurrent connections/requests — well under the 25 new connections/sec or 3,000 active connections a single LCU covers)
- 20 GB/month of data transferred out to clients via the ALB
- RDS not separately backed up beyond the included automated backup (no extra snapshot storage costed)

## Cost breakdown

| Category | Item | Driver | Rate | Monthly cost |
|---|---|---|---|---|
| Compute | NAT instance (t2.micro) | 730 h | $0.0116/h | $8.47 |
| Compute | Bastion (t2.micro) | 730 h | $0.0116/h | $8.47 |
| Compute | ASG web ×2 (t2.micro) | 2 × 730 h | $0.0116/h | $16.94 |
| Block storage | EBS root volumes ×4 (gp3, 30 GB each) | 120 GB | $0.08/GB | $9.60 |
| Load balancer | ALB base | 730 h | $0.0225/h | $16.43 |
| Load balancer | ALB LCU-hours | ~730 LCU-h | $0.008/LCU-h | $5.84 |
| Database | RDS db.t3.micro, Multi-AZ (compute) | 730 h | $0.06/h (Multi-AZ = 2× Single-AZ $0.03/h) | $43.80 |
| Database | RDS storage, Multi-AZ (20 GB × 2 copies) | 40 GB | $0.115/GB | $4.60 |
| Network | Data transfer out via ALB | 20 GB | $0.09/GB | $1.80 |
| **Total** | | | | **$115.95** |

*Note: AWS's 100 GB/month free data-transfer-out tier (aggregated across services) would likely make the $1.80 line $0 in practice — shown at full price to keep the cost driver visible, same approach as C-1-B.*

## Why NAT instance instead of managed NAT Gateway (cost comparison)

This was an explicit design decision in F-1-A — worth quantifying here:

| | NAT instance (chosen) | Managed NAT Gateway |
|---|---|---|
| Base cost | $8.47/mo (t2.micro) | $32.85/mo (730h × $0.045/h) |
| Data processing fee | None | $0.045/GB processed |
| Estimated total (at this scenario's traffic) | $8.47/mo | ~$33.75/mo+ |

Choosing the NAT instance saves roughly **$25/month** at this traffic level — the tradeoff (single point of failure, no AWS-managed patching) was already justified in the F-1-A documentation as acceptable for a lab budget without a production SLA.

## Biggest cost drivers

1. **RDS Multi-AZ compute** ($43.80) — almost 40% of the bill. Multi-AZ literally doubles the single-instance price; this is the cost of the HA database requirement from I-1-A.
2. **ALB** ($22.27) — mostly the fixed hourly base charge, not traffic-driven at this scale.
3. **EC2 compute** ($33.88 combined) — four always-on t2.micro instances (NAT, bastion, 2× web).

## Status

- [x] Real infrastructure costed (same architecture as I-1-A / F-1-A)
- [x] Cost factors identified per category
- [x] Realistic scenario calculated, assumptions documented
- [x] Results presented in a structured table + CSV

See `costs.csv` for the same breakdown in spreadsheet form.

**C-1-I complete.**
