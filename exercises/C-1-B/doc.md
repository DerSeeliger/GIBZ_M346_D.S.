# C-1-B — Estimate costs (Beginner)

> I can calculate the operating costs for individual cloud services.

## Task

Select two individual services, identify their cost drivers, calculate expected monthly cost for a realistic usage scenario, present the results.

No infrastructure change for this competency — it's a calculation exercise. The two services below are the same ones already running in this project (E-1-B EC2 instance, D-1-B S3 bucket), so the numbers are grounded in real config, not a random example.

## Service 1: Amazon EC2 (t2.micro) — Compute

**Cost driver:** instance hours running (you pay per hour/second the instance is on, regardless of CPU load).

**Pricing (us-east-1, on-demand Linux):** $0.0116 / hour

**Usage scenario:** the `web_a` instance from E-1-B runs 24/7 all month → 730 hours.

| Driver | Quantity | Rate | Cost |
|---|---|---|---|
| Instance hours | 730 h | $0.0116 / h | **$8.47** |

## Service 2: Amazon S3 — Object Storage

**Cost drivers:** amount of data stored (GB-month), number of PUT/COPY/POST/LIST requests, number of GET requests, data transferred out to the internet.

**Pricing (us-east-1, S3 Standard):**
- Storage: $0.023 / GB / month
- PUT/COPY/POST/LIST: $0.005 / 1,000 requests
- GET: $0.0004 / 1,000 requests
- Data transfer out: $0.09 / GB

**Usage scenario:** the `m346-storage` bucket from D-1-B holding app data/backups for a small app — 50 GB stored, 20,000 uploads/month, 200,000 downloads/month, 10 GB transferred out.

| Driver | Quantity | Rate | Cost |
|---|---|---|---|
| Storage | 50 GB | $0.023 / GB | $1.15 |
| PUT/COPY/POST/LIST requests | 20,000 | $0.005 / 1,000 | $0.10 |
| GET requests | 200,000 | $0.0004 / 1,000 | $0.08 |
| Data transfer out | 10 GB | $0.09 / GB | $0.90 |
| **Total** | | | **$2.23** |

*Note: AWS gives 100 GB/month of data transfer out free across all services combined — in reality this 10 GB would likely be free. The $0.90 above is shown deliberately to illustrate transfer as a cost driver.*

## Total estimated monthly cost

| Service | Monthly cost |
|---|---|
| EC2 (t2.micro, 24/7) | $8.47 |
| S3 (50 GB + requests + transfer) | $2.23 |
| **Total** | **$10.70** |

See `costs.csv` for the same breakdown in spreadsheet form.

## Sources

- [Amazon S3 Pricing](https://aws.amazon.com/s3/pricing/)
- [Amazon EC2 t2.micro pricing — economize.cloud](https://www.economize.cloud/resources/aws/pricing/ec2/t2.micro/)

## Screenshots

None required for this competency — it's a pure cost calculation, no console/infra changes were made.

## Status

- [x] Two services selected (EC2, S3)
- [x] Cost drivers identified
- [x] Monthly costs calculated for realistic scenario
- [x] Report + spreadsheet produced

**C-1-B complete.**
