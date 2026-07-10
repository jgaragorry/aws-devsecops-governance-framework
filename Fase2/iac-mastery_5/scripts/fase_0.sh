#!/bin/bash
# ==============================================================================
# FASE 0 (COMPLETA Y FORZADA): REEMPLAZO DIRECTO DE BINARIOS PARA ÚLTIMAS VERSIONES
# SRE Best Practices: Rompiendo dependencias de repositorios obsoletos.
# ==============================================================================
set -e

echo "=== 1. Limpieza de Caché y Preparación ==="
sudo apt-get update && sudo apt-get install -y curl unzip jq

echo "=== 2. Actualizando AWS CLI v2 ==="
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
cd /tmp && unzip -q -o awscliv2.zip
sudo ./aws/install --update
rm -rf aws awscliv2.zip && cd - > /dev/null

echo "=== 3. Actualizando Azure CLI ==="
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "=== 4. FORZANDO ÚLTIMA VERSIÓN DE TERRAFORM (Descarga Directa de Binario) ==="
# Removemos la versión vieja de apt para evitar conflictos de rutas
sudo apt-get remove terraform -y || true
sudo rm -f /usr/bin/terraform /usr/local/bin/terraform

# Consultamos a la API de HashiCorp cuál es la última versión real estable
LATEST_TF=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
echo "Última versión oficial de Terraform detectada en HashiCorp: v$LATEST_TF"

# Descargamos el binario oficial compilado para Linux de 64 bits
curl -s "https://releases.hashicorp.com/terraform/${LATEST_TF}/terraform_${LATEST_TF}_linux_amd64.zip" -o "/tmp/terraform.zip"
cd /tmp && unzip -q -o terraform.zip
sudo mv terraform /usr/local/bin/terraform
rm -f terraform.zip && cd - > /dev/null

echo "=== 5. Sincronizando Última Versión de Terragrunt ==="
TG_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | jq -r .name)
curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_amd64" -o /tmp/terragrunt
chmod +x /tmp/terragrunt
sudo mv /tmp/terragrunt /usr/local/bin/terragrunt

echo "=== 6. Actualizando Infracost ==="
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# ==============================================================================
# AUDITORÍA DE VERIFICACIÓN TOTAL
# ==============================================================================
echo -e "\n======================================================="
echo "   VERIFICACIÓN DE COMPONENTES ACTUALIZADOS AL 100%"
echo "======================================================="
aws --version
echo "-------------------------------------------------------"
az version | head -n 2
echo "-------------------------------------------------------"
terraform -version
echo "-------------------------------------------------------"
terragrunt -version
echo "-------------------------------------------------------"
infracost --version
echo "======================================================="
