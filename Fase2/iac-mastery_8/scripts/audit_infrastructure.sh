#!/bin/bash
echo "=========================================================="
echo "   🔍 AUDITORÍA FORENSE SRE: DETECCIÓN DE RECURSOS ACTIVOS"
echo "=========================================================="

echo "📦 Revisando Buckets S3..."
BUCKETS=$(aws s3 ls | grep -E "sre-linux|mi-bucket" || true)
if [ -z "$BUCKETS" ]; then
    echo "✅ S3: 100% Limpio. No quedan remanentes en la cuenta."
else
    echo "⚠️ ALERTA: Quedan buckets activos:"
    echo "$BUCKETS"
fi

echo "🖥️ Revisando Instancias EC2..."
INSTANCES=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=pending,running,stopping,stopped" --query "Reservations[*].Instances[*].[InstanceId,State.Name]" --output text)
if [ -z "$INSTANCES" ]; then
    echo "✅ EC2: 100% Limpio. No hay servidores activos."
else
    echo "⚠️ ALERTA: Instancias EC2 remanentes detectadas:"
    echo "$INSTANCES"
fi
echo "=========================================================="
