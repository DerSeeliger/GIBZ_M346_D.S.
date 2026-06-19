#!/bin/bash
dnf update -y
dnf install -y nginx

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

cat > /usr/share/nginx/html/index.html << EOF
<!DOCTYPE html>
<html>
<head><title>M346 F-1-A / I-1-A — HA Web Tier</title>
<style>body{font-family:sans-serif;max-width:600px;margin:50px auto;padding:20px;background:#f5f5f5}
h1{color:#232f3e}.info{background:white;padding:20px;border-radius:8px;border-left:4px solid #ff9900}</style>
</head>
<body>
<h1>M346 HA Architecture (F-1-A / I-1-A)</h1>
<div class="info">
  <p><strong>Student:</strong> david-seeliger</p>
  <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
  <p><strong>Availability Zone:</strong> $AZ</p>
  <p><strong>Private IP:</strong> $PRIVATE_IP</p>
  <p><strong>Tier:</strong> Web (Auto Scaling Group, private subnet, behind ALB)</p>
</div>
</body>
</html>
EOF

systemctl start nginx
systemctl enable nginx
