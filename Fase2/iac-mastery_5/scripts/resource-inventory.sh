#!/bin/bash
echo "=========================================================="
echo "    INVENTARIO DE RECURSOS VIVOS EN MULTI-CLOUD (SRE)"
echo "=========================================================="

echo "🔎 [AWS] Instancias EC2 Virtuales Activas:"
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].[InstanceId,PublicIpAddress,Tags[?Key=='Name'].Value|[0]]" \
  --output table

echo "🔎 [AWS] Firewalls (Security Groups) Creados:"
aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=firewall-sre-*" \
  --query "SecurityGroups[*].[GroupId,GroupName,VpcId]" \
  --output table

echo "🔎 [AZURE] Máquinas Virtuales Activas:"
az vm list --query "[?contains(name, 'sre') || contains(name, 'az')].{Name:name, ResourceGroup:resourceGroup, Location:location}" --output table

echo "🔎 [AZURE] Interfaces de Red e IPs Públicas Activas:"
az network public-ip list --query "[?contains(name, 'sre')].{Name:name, IP:ipAddress, Status:provisioningState}" --output table
echo "=========================================================="
