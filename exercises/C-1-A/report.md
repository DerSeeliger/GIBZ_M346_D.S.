# C-1-A — Estimate costs (Advanced, includes C-1-I & C-1-B)

> Identify and justify cost optimization options for the infrastructure designed and costed in C-1-I.

Assessed via a written report **and** a short technical discussion — this doc is both. Baseline: `project/docs/C-1-I/doc.md`, total **$115.95/month**.

## Optimization 1 — Switch on-demand instances to Graviton (ARM, `t4g.micro`)

**Measure:** Replace `t2.micro` (x86, Intel) with `t4g.micro` (ARM, Graviton2) for the NAT instance, bastion, and ASG web tier launch template.

**Cost reduction:** $0.0116/h → $0.0084/h, about 28% cheaper per instance-hour.

| | Before (t2.micro) | After (t4g.micro) |
|---|---|---|
| 4 instances × 730h | $33.88/mo | $24.53/mo |
| **Savings** | | **$9.35/mo (~28%)** |

**Trade-offs / limitations:**
- ARM architecture — every package/binary running on these instances must have an ARM build. Our stack (nginx, the NAT `iptables` setup, `mariadb105` client) all support ARM, so this is low-risk here, but it's not automatic for arbitrary software.
- Requires switching the AMI data source from `al2023-ami-*-x86_64` to the ARM AL2023 AMI and updating `instance_type` everywhere — a real (if small) Terraform change, not just a cost-model exercise.

## Optimization 2 — Right-size EBS root volumes (30 GB → 8 GB)

**Measure:** Every EC2 instance in this architecture is running the AL2023 default root volume size (30 GB), even though none of these roles (NAT, bastion, simple web server) need anywhere close to that. Set an explicit `root_block_device { volume_size = 8 }` in the launch template / instance resources.

**Cost reduction:** 4 instances × 30 GB × $0.08/GB → 4 × 8 GB × $0.08/GB.

| | Before | After |
|---|---|---|
| EBS root storage | $9.60/mo | $2.56/mo |
| **Savings** | | **$7.04/mo (~73%)** |

**Trade-offs / limitations:**
- Less headroom for package caches, logs, and core dumps — a runaway log file fills disk much faster on 8 GB than 30 GB.
- Should be paired with basic disk-usage monitoring/alerting; without it, this optimization trades a cost risk for an availability risk.

## Optimization 3 — 1-year No Upfront Compute Savings Plan

**Measure:** Commit the steady-state EC2 usage (NAT + bastion + ASG baseline, all running 24/7) to a Compute Savings Plan instead of paying on-demand rates.

**Cost reduction:** Typical discount for a 1-year No Upfront Compute Savings Plan is around 28% off on-demand.

| | Before (on-demand) | After (Savings Plan) |
|---|---|---|
| EC2 compute (baseline, t2.micro) | $33.88/mo | ~$24.39/mo |
| **Savings** | | **~$9.49/mo (~28%)** |

**Trade-offs / limitations:**
- 1-year commitment to a minimum hourly spend, billed whether or not the instances actually run that much.
- Reduces flexibility to also apply Optimization 1 (Graviton) or to shrink the architecture later — the commitment is sized to current usage, so any reduction in actual compute usage wastes part of the committed spend. In practice you'd choose **either** Graviton **or** a Savings Plan as the first lever, not blindly stack both without re-checking the math.

## Optimization 4 — Scheduled Auto Scaling (scale-in during off-peak hours)

**Measure:** Add a scheduled scaling action that drops the ASG desired capacity from 2 to 1 during a known low-traffic window (e.g. 8 hours overnight), scaling back to 2 before peak hours.

**Cost reduction:** 1 fewer instance × 8h/day × 30 days × $0.0116/h ≈ **$2.78/mo**.

**Trade-offs / limitations:**
- Directly reduces the redundancy the architecture was built for — during the scale-in window there is only one web instance, i.e. only one AZ is actually serving traffic. This partially defeats the HA goal from I-1-A for that window.
- The dollar saving here is small (because t2.micro is already cheap) — this lever matters far more on larger instance types; included here for completeness and because it's a real, commonly-used pattern, not because it's the biggest win in this specific architecture.

## Considered and rejected — RDS to Single-AZ

**Measure considered:** Switch RDS from Multi-AZ to Single-AZ.

**Why it's the single biggest theoretical saving:** Multi-AZ exactly doubles both RDS compute and storage cost. Single-AZ would cut the RDS line from $48.40/mo to ~$24.20/mo — a **$24.20/mo** saving, more than all four optimizations above combined.

**Why it's rejected for this architecture:** I-1-A was specifically built to demonstrate a highly-available database with automatic failover. Removing Multi-AZ removes exactly the property that competency was assessed on — it's not a tuning knob here, it's undoing the requirement. **Recommendation:** keep Multi-AZ for this environment; this lever is the right one to pull only for a genuine dev/staging clone of the infrastructure that doesn't need the HA guarantee (e.g. a separate, smaller RDS instance used only for local testing).

## Combined effect (discussion estimate)

Applying Optimizations 1, 2 and 4 together (skipping the Savings Plan, since it overlaps with Optimization 1 and would need re-pricing, not naive stacking, to combine correctly):

| Component | Baseline (C-1-I) | Optimized |
|---|---|---|
| EC2 compute | $33.88 | $22.51 (Graviton + scheduled scale-in) |
| EBS root storage | $9.60 | $2.56 |
| ALB | $22.27 | $22.27 (unchanged) |
| RDS Multi-AZ | $48.40 | $48.40 (unchanged — kept for HA) |
| Data transfer | $1.80 | $1.80 (unchanged) |
| **Total** | **$115.95** | **$97.54** |

**~16% reduction ($18.41/mo) without touching availability or locking into a 1-year commitment.** Adding the Savings Plan on top would push this further (~$91/mo, ~21% total) but that figure needs re-validating with the AWS Pricing Calculator rather than naively multiplying percentages.

## Discussion talking points

- Be ready to justify *why* RDS Multi-AZ was kept despite being the biggest lever — ties directly back to the I-1-A requirement.
- Be ready to explain the Graviton trade-off in terms of architecture risk (binary compatibility), not just price.
- Distinguish "tuning knobs with no real downside" (EBS right-sizing, Graviton) from "tuning knobs with a real trade-off" (scheduled scale-in, Savings Plan commitment, RDS Single-AZ) — this is the actual point of the competency, not just finding the cheapest possible number.

## Status

- [x] Cost calculation reviewed (C-1-I)
- [x] 4 optimization measures identified, described, cost-reduction quantified, trade-offs discussed
- [x] 1 measure considered and explicitly rejected with justification
- [x] Combined estimate produced
- [ ] Technical discussion with teacher

**C-1-A report complete — ready for the technical discussion (includes C-1-I & C-1-B).**
