# I-1-A — Design operational architecture (Advanced, includes I-1-I & I-1-B)

> Develop a highly available operational architecture that meets customer requirements and is maintainable and resilient.

Assessed via a **technical discussion**, not a Moodle submission — this doc is talking-point prep, not something to hand in directly. Architecture is the same build as F-1-A (`project/terraform/F/`) — see `../F-1-A/diagram.md` for the diagram.

## 1. Use case / requirements analysis

**Use case:** a small web application (e.g. an internal tool or small e-commerce-style site) that needs to:
- Stay available if a single server or a single Availability Zone fails
- Scale out automatically under load instead of being capacity-planned by hand
- Keep its database from being a single point of failure
- Keep the database and app servers off the public internet — only the load balancer should be reachable directly
- Stay maintainable: adding capacity or replacing a failed component shouldn't require manual intervention

These requirements map directly onto: multi-AZ, ASG, RDS Multi-AZ, private subnets + security groups, NAT for outbound patching.

## 2. Architecture decisions and justification (talking points)

**Why a VPC with public/private subnets across 2 AZs, instead of the default VPC?**
The default VPC has no private subnets and no control over CIDR ranges — fine for the early single-instance competencies (E-1-B), not adequate once the requirement is "internal tiers must not be internet-reachable." A custom VPC gives explicit control over routing and isolation, and AZ-redundant subnets are the foundation everything else (ASG, RDS Multi-AZ) depends on.

**Why an Application Load Balancer + Auto Scaling Group instead of fixed EC2 instances?**
A fixed pair of instances (as in E-1-B/H-1) doesn't self-heal — if one dies, it stays dead until someone notices. An ASG with an ELB health check replaces unhealthy instances automatically, and decouples "how many servers" from "how the app is deployed" (launch template), so scaling is a config change, not a rebuild. This is what "maintainable" means in the competency description.

**Why NAT instance rather than NAT Gateway?**
Justify as a deliberate cost/availability tradeoff, not an oversight: a NAT Gateway is the textbook HA-correct choice (AWS-managed, scales automatically, no single point of failure if you deploy one per AZ), but it bills continuously per hour plus data processed. In an Academy lab with a fixed time-boxed credit, a NAT instance is "good enough" availability for the egress-only traffic it carries (private instances pulling OS updates), at a fraction of the cost. In a real production environment with a real SLA, I would justify switching to a NAT Gateway per AZ instead.

**Why RDS Multi-AZ instead of a self-managed database on EC2?**
Self-managed replication (e.g. manual MySQL master/replica) means owning failover logic, monitoring lag, and promoting a replica by hand during an incident. RDS Multi-AZ gives synchronous replication and automatic failover (typically under a minute) as a managed feature — directly satisfies "HA database" without reinventing it.

**Why is the database in a private subnet with `publicly_accessible = false`, reachable only from the web tier's security group (plus the bastion)?**
Defense in depth — even if the web tier were compromised, the blast radius for direct internet access to the DB is zero, because there's no route to it from outside the VPC at all (no public IP, no route table path), not just a firewall rule.

**Why a bastion host instead of e.g. SSM Session Manager?**
Simplicity for a time-boxed lab exercise — a bastion with a tightly scoped security group (only my IP, port 22) is a pattern that's easy to explain and demo live. In a real long-lived environment, I'd point out that AWS Systems Manager Session Manager removes the need for an always-on SSH-exposed box entirely, which I'd recommend going forward.

**What would I add next for even higher resilience?**
- NAT Gateway per AZ (eliminate the NAT instance SPOF)
- Multi-region failover for true disaster recovery
- CloudWatch alarms + SNS to alert on ASG/RDS failover events, not just rely on AWS handling it silently
- WAF in front of the ALB for basic application-layer protection

## 3. Demo plan for the discussion

1. Show the diagram, walk through the request path: internet → IGW → ALB → ASG (private subnet) → RDS (private subnet, Multi-AZ)
2. Open the AWS console: VPC resource map, ASG showing 2 healthy instances across 2 AZs, RDS showing Multi-AZ: Yes
3. Optional live resilience demo: terminate one ASG instance from the console — watch the ASG launch a replacement and the ALB target group recover (takes a few minutes, decide beforehand whether there's time during the appointment)
4. Be ready to explain every box in the diagram and trace a request through it without notes

## Status

- [x] Requirements analysis written
- [x] Architecture justifications prepared
- [ ] Appointment booked with teacher
