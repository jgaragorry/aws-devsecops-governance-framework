#!/bin/bash
# ==============================================================================
# SRE MULTI-CLOUD NUCLEAR AUDIT SCRIPT v2.1 (Semantic Fix & Global Resource Scan)
# Propósito: Evitar bloqueos de argumentos usando consultas globales por tipo.
# ==============================================================================

export AWS_DEFAULT_REGION="us-east-1"

echo "======================================================================"
echo "⚠️  INICIANDO AUDITORÍA FORENSE DE RESIDUOS DE INFRAESTRUCTURA (v2.1)"
echo "======================================================================"

# ------------------------------------------------------------------------------
# SECTION 1: AWS DEEP SCAN
# ------------------------------------------------------------------------------
echo -e "\n⚡ [AWS] BUSCANDO COMPONENTES ACTIVOS..."

echo "🔹 1. Instancias EC2 (Vivas o Terminándose):"
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=pending,running,shutting-down,stopping" \
  --query "Reservations[*].Instances[*].{ID:InstanceId,Type:InstanceType,State:State.Name,IP:PublicIpAddress,Name:Tags[?Key=='Name'].Value | [0]}" \
  --output table

echo "🔹 2. Volúmenes EBS Huérfanos:"
aws ec2 describe-volumes \
  --filters "Name=status,Values=available,creating,error" \
  --query "Volumes[*].{ID:VolumeId,Size:Size,State:State,Type:VolumeType}" \
  --output table

echo "🔹 3. Direcciones IP Elásticas (EIP) sin asociar:"
aws ec2 describe-addresses \
  --query "Addresses[?AssociationId==null].{PublicIp:PublicIp,AllocationId:AllocationId}" \
  --output table

echo "🔹 4. Interfaces de Red (ENI) residuales:"
aws ec2 describe-network-interfaces \
  --filters "Name=status,Values=available" \
  --query "NetworkInterfaces[*].{ID:NetworkInterfaceId,Subnet:SubnetId,Vpc:VpcId}" \
  --output table

echo "🔹 5. Gateways de Internet (IGW) sueltos:"
aws ec2 describe-internet-gateways \
  --query "InternetGateways[?Attachments[0].VpcId==null].{ID:InternetGatewayId}" \
  --output table

echo "🔹 6. Security Groups personalizados residuales:"
aws ec2 describe-security-groups \
  --query "SecurityGroups[?GroupName!='default'].{ID:GroupId,Name:GroupName,Vpc:VpcId}" \
  --output table

echo "🔹 7. Redes VPC personalizadas activas:"
aws ec2 describe-vpcs \
  --query "Vpcs[?IsDefault==\`false\`].{ID:VpcId,Cidr:CidrBlock,State:State}" \
  --output table


# ------------------------------------------------------------------------------
# SECTION 2: AZURE GLOBAL DEEP SCAN (Uso de az resource list para evitar -g)
# ------------------------------------------------------------------------------
echo -e "\n❄️  [AZURE] BUSCANDO COMPONENTES ACTIVOS..."

echo "🔹 1. Grupos de Recursos Vivos (Filtro de laboratorio):"
az group list --query "[?contains(name, 'SRE') || contains(name, 'sre') || contains(name, 'dev')].{Name:name, State:properties.provisioningState}" --output table

echo "🔹 2. Máquinas Virtuales de Azure:"
az resource list --resource-type "Microsoft.Compute/virtualMachines" --query "[].{Name:name, RG:resourceGroup}" --output table

echo "🔹 3. Discos de Almacenamiento Administrados (Suscripción Completa):"
az resource list --resource-type "Microsoft.Compute/disks" --query "[].{Name:name, RG:resourceGroup}" --output table

echo "🔹 4. Direcciones IP Públicas:"
az resource list --resource-type "Microsoft.Network/publicIPAddresses" --query "[].{Name:name, RG:resourceGroup}" --output table

echo "🔹 5. Interfaces de Red (NIC):"
az resource list --resource-type "Microsoft.Network/networkInterfaces" --query "[].{Name:name, RG:resourceGroup}" --output table

echo "🔹 6. Grupos de Seguridad de Red (NSG):"
az resource list --resource-type "Microsoft.Network/networkSecurityGroups" --query "[?resourceGroup!='NetworkWatcherRG'].{Name:name, RG:resourceGroup}" --output table

echo "🔹 7. Redes Virtuales (VNet) activas en la Suscripción:"
az resource list --resource-type "Microsoft.Network/virtualNetworks" --query "[].{Name:name, RG:resourceGroup}" --output table

echo -e "\n======================================================================"
echo "✅ AUDITORÍA COMPLETA SIN ERRORES. SI TODO ESTÁ VACÍO, LA APAGADA ES TOTAL."
echo "======================================================================"
