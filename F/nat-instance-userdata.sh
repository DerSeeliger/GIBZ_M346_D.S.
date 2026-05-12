#!/bin/bash
# Configure this EC2 instance as a NAT device for private subnets.
# IP forwarding + masquerade rule = any private EC2 can reach internet through this instance.

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# Detect the primary interface name (enX0 on Xen, ens5 on Nitro)
IFACE=$(ip route show default | awk '/default/ {print $5}')

dnf install -y iptables-services
iptables -t nat -A POSTROUTING -o "$IFACE" -j MASQUERADE
service iptables save
systemctl enable iptables
systemctl start iptables
