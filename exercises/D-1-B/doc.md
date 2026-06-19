# D-1-B — Determine and operate storage services (Beginner)

> I can distinguish between the three main types of data, name their differences, name suitable cloud storage services and put them into operation according to specifications.

## Task

Select at least two different cloud storage services, set them up with defined access permissions/configuration, upload example data, verify functionality, and document the process.

## Services chosen

| # | Service | Storage type | AWS resource |
|---|---------|-------------|---------------|
| 1 | Amazon S3 | Object storage | `aws_s3_bucket.storage` — bucket `m346-storage-david-seeliger` |
| 2 | Amazon EBS | Block storage | `aws_ebs_volume.data` — volume `vol-0daed2939817fd628` (gp3, 10 GiB), attached as `/dev/xvdf` to EC2 instance `i-04c6318279ba14079` |

Terraform source: `project/terraform/D/main.tf`

## 1. Object storage — Amazon S3

**Configuration:**
- Bucket: `m346-storage-david-seeliger`, region `us-east-1`
- Versioning: **Enabled** (`aws_s3_bucket_versioning`)
- Access permissions: all public access blocked (`aws_s3_bucket_public_access_block` — ACLs, bucket policy, and public buckets all blocked)
- Encryption: server-side encryption at rest, AES256 (`aws_s3_bucket_server_side_encryption_configuration`)

**Example data uploaded:**
- Object key `d1b-verification.txt`, uploaded via Terraform (`aws_s3_object.verification`)
- Uploaded twice to demonstrate versioning is actually working:
  1. **v1** content (`test-data-v1.txt`) — applied first
  2. **v2** content (`test-data-v2.txt`) — applied second, overwriting the same key

**Verification:**
- After each apply, the object's `version_id` is shown in Terraform output (`s3_verification_version_id`)
- S3 console → bucket → object → "Versions" tab shows both versions present, proving versioning works
- Public access block + encryption settings visible under bucket → Permissions / Properties tabs

## 2. Block storage — Amazon EBS

**Configuration:**
- Volume `vol-0daed2939817fd628`, type `gp3`, size 10 GiB, same AZ as EC2 instance `web_a`
- Attached to instance `i-04c6318279ba14079` as device `/dev/xvdf` (`aws_volume_attachment.data`)
- Filesystem: XFS, mounted at `/mnt/block-storage`, persisted via `/etc/fstab` entry (`nofail` so boot doesn't hang if detached)
- Access: only reachable via SSH to the EC2 instance using `m346-key.pem` — no public/network exposure of the raw block device

**Example data uploaded:**
- File `/mnt/block-storage/d1b-verification.txt` written directly on the mounted volume containing student name, volume ID and mount point

**Verification:**
- `lsblk` on the instance shows `xvdf` 10G mounted at `/mnt/block-storage`
- `df -h /mnt/block-storage` shows the filesystem mounted with available space
- `cat /mnt/block-storage/d1b-verification.txt` shows the file content was written and persists on the block device

## Screenshots to take

Save each screenshot — when done say **"task done"** and they'll be sorted into `project/docs/D-1-B/screenshots/` with descriptive names.

1. **S3 console — bucket overview** (shows bucket name, region)
2. **S3 console — bucket Permissions tab** (shows public access blocked)
3. **S3 console — bucket Properties tab** (shows encryption + versioning enabled)
4. **S3 console — object `d1b-verification.txt` → Versions tab, after v1 apply** (shows 1 version)
5. *(after v2 apply, on command)* **S3 console — same Versions tab, now showing 2 versions** — proves versioning works
6. **EBS console — volume `vol-0daed2939817fd628`** (shows state "in-use", size 10 GiB, attached instance)
7. **Terminal — SSH session showing `lsblk`, `df -h /mnt/block-storage`, and `cat /mnt/block-storage/d1b-verification.txt` output**

## Status

- [x] S3 bucket created, versioning/encryption/public-access-block configured
- [x] EBS volume created and attached
- [x] EBS formatted, mounted, verification file written
- [x] S3 object v1 uploaded
- [x] S3 object v2 uploaded
- [x] Screenshots collected — see `screenshots/01` through `06`

**D-1-B complete.**
