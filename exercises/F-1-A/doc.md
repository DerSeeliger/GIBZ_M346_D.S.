# F-1-A — Design and operate network architecture (Advanced, includes F-1-I & F-1-B)

> Expand the network from F-1-I to include HA options and scalability: multiple subnets in different AZs, etc.

See `diagram.md` in this folder for the network diagram.

## What was built

Terraform source: `project/terraform/F/`

| Element | Implementation |
|---|---|
| VPC | `10.0.0.0/16`, custom (separate from the default-VPC infra used by E/D/H) |
| Public subnets | `10.0.1.0/24` (AZ-a), `10.0.3.0/24` (AZ-b) |
| Private subnets | `10.0.2.0/24` (AZ-a), `10.0.4.0/24` (AZ-b) |
| Internet Gateway | attached to the VPC, routed from public subnets |
| NAT | NAT **instance** (t2.micro) in public subnet AZ-a — cheaper than a managed NAT Gateway for an Academy lab budget; private route table points at its network interface |
| Web server | Auto Scaling Group (t2.micro, min 2/max 4/desired 2) across both private subnets, behind an Application Load Balancer in the public subnets |
| Database server | RDS MySQL 8.0, Multi-AZ, in a DB subnet group spanning both private subnets — not publicly accessible |
| Security groups | ALB (80 from internet) → Web (80 from ALB SG, 22 from bastion SG) → RDS (3306 from web SG + bastion SG); NAT SG (all traffic from VPC CIDR only); Bastion SG (22 from my IP only) |
| Bastion host | t2.micro in public subnet AZ-b, only reachable via SSH from my own IP — used to reach the private web/DB tier for verification |

## Why these choices

- **2 AZs everywhere** — a single-AZ design has the AZ itself as a single point of failure; spreading subnets/ASG/RDS standby across 2 AZs means an AZ outage doesn't take the app down.
- **NAT instance over NAT Gateway** — a managed NAT Gateway is more resilient (AWS-managed, no patching) but bills per-hour plus per-GB; a NAT instance is a single point of failure but costs a fraction as much, which is the right tradeoff for a lab environment with a limited budget and no production SLA.
- **ASG instead of fixed instances** — handles instance failure (auto-replaces unhealthy instances via the ELB health check) and scale (min 2 baseline for HA, can grow to 4 under load).
- **RDS Multi-AZ instead of a single DB instance** — synchronous standby in the second AZ with automatic failover; this is the standard AWS pattern for an HA relational database without building custom replication.
- **Web tier moved to private subnets behind the ALB** (vs. F-1-B/I's literal "web server in the public subnet") — this is the natural evolution for the Advanced/HA version: direct public exposure of app servers is bad practice once you have a load balancer to do that job; the ALB is the only public-facing piece of the web tier.
- **Bastion host** — without it, the only way to verify the private tier works would be the ALB response and CloudWatch metrics; the bastion lets us actually SSH in and query the DB directly for proof.

## Troubleshooting hit during build (good discussion material)

Two real bugs surfaced and were fixed — both now permanently baked into the Terraform/userdata:

1. **NAT instance silently dropped all forwarded traffic.** AL2023's base image ships with the iptables `FORWARD` chain default policy set to `DROP` (likely a Docker-related default). The NAT instance had `ip_forward=1` and a correct `MASQUERADE` rule, but the kernel's forwarding decision never reached the `MASQUERADE` rule because `FORWARD` dropped the packet first. Fixed by adding explicit `ACCEPT` rules for traffic to/from the VPC CIDR in `FORWARD`. Without this, private-subnet instances had zero internet egress — `dnf install` just hung until ALB health checks failed and the ASG kept cycling instances forever.
2. **`dnf install -y nginx mysql` failed outright** — `mysql` isn't a real AL2023 package name (the client is `mariadb105`), so the whole transaction aborted and nginx never got installed either, even after issue #1 was fixed. Removed `mysql` from the web tier (it doesn't need a DB client) and added it only to the bastion, which is where DB verification actually happens.

## Live values (this session)

- VPC: `vpc-0f689e868a23bad73`
- ALB URL: `http://m346-alb-ha-david-seeliger-1860698094.us-east-1.elb.amazonaws.com`
- RDS endpoint: `m346-db-david-seeliger.ci5blxtut1z3.us-east-1.rds.amazonaws.com:3306`
- Bastion: `ssh -i m346-key.pem ec2-user@<bastion_ip>` (run `terraform output f1a_bastion_ssh` for the current IP — changes each Academy session)
- DB password: `project/terraform/db-password.txt` (generated, not in any .tf file)

## Screenshots to take

Take and save, then say "task done":

1. **VPC console** — resource map view showing the VPC with both AZs, subnets, route tables
2. **Subnets list** — showing all 4 subnets with their CIDR blocks and AZ column
3. **Route tables** — public route table (0.0.0.0/0 → IGW) and private route table (0.0.0.0/0 → NAT instance ENI)
4. **EC2 → Auto Scaling Groups** — showing the ASG with 2 running instances, desired/min/max capacity
5. **EC2 → Target Groups → Targets tab** — both ASG instances healthy
6. **Browser** — the ALB URL loaded, showing the Nginx page (already verified live — see "Status" below)
7. **RDS console** — DB instance showing Multi-AZ: Yes, status available
8. **Terminal** — SSH to bastion, then run the RDS query below, to prove the private tier is reachable only from inside the VPC:
   ```
   ssh -i m346-key.pem ec2-user@<bastion_ip>
   mysql -h m346-db-david-seeliger.ci5blxtut1z3.us-east-1.rds.amazonaws.com -u admin -p'<password from db-password.txt>' -e 'SELECT @@hostname, @@version, NOW();'
   ```

## Status

- [x] Terraform written
- [x] Applied — all resources live, two real bugs found and fixed (NAT forwarding, package name)
- [x] Functionally verified: ALB serves the page, ASG has 2 healthy instances across 2 AZs, RDS Multi-AZ available and reachable from bastion
- [x] Screenshots collected — see `screenshots/01` through `08`

**F-1-A complete (includes F-1-I & F-1-B).**
