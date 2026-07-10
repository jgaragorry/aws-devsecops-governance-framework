#!/bin/bash

# ==============================================================================
# SRE Phase 0 - Environment Bootstrap (Idempotent)
# Target OS: Ubuntu 24.04 LTS (Noble Numbat)
# Roles: SRE / Cloud Architect / DevOps
# ==============================================================================

set -e # Detener ante cualquier error

# --- 1. PRE-CHECK DE SEGURIDAD (OS VALIDATION) ---
OS_VERSION=$(lsb_release -rs 2>/dev/null || echo "unknown")
OS_NAME=$(lsb_release -is 2>/dev/null || echo "unknown")

echo "🔍 Iniciando Pre-chequeo de compatibilidad..."

if [[ "$OS_NAME" != "Ubuntu" ]] || [[ "$OS_VERSION" != "24.04" ]]; then
    echo "❌ ERROR: Este script solo es compatible con Ubuntu 24.04 LTS."
    echo "Distro detectada: $OS_NAME $OS_VERSION"
    echo "Por favor, utiliza la imagen correcta para evitar Drift Condition."
    exit 1
fi

echo "✅ Compatibilidad validada (Ubuntu 24.04 LTS)."

# --- 2. ACTUALIZACIÓN E IDEMPOTENCIA DE REPOSITORIOS ---
echo "🔄 Actualizando índices de paquetes..."
sudo apt-get update && sudo apt-get upgrade -y

# --- 3. INSTALACIÓN DE DEPENDENCIAS BASE ---
echo "🔗 Instalando librerías y herramientas core..."
sudo apt-get install -y \
    ca-certificates curl gnupg lsb-release \
    unzip jq build-essential software-properties-common \
    wget git-core zlib1g-dev libssl-dev

# --- 4. INSTALACIÓN DE MODERN UNIX TOOLS (RUST/GO BASED) ---
echo "🦀 Instalando Modern Tooling (btm, eza, bat, duf, lnav)..."

# eza (Modern ls)
if ! command -v eza &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt-get update && sudo apt-get install -y eza
fi

# bat (Modern cat) - En Ubuntu se llama 'batcat'
sudo apt-get install -y bat duf lnav btop

# --- 5. IAC STACK (TERRAFORM, TERRAGRUNT, ANSIBLE) ---
echo "🏗️  Configurando IaC Stack..."

# Terraform
if ! command -v terraform &> /dev/null; then
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update && sudo apt-get install -y terraform
fi

# Terragrunt (Idempotente)
if ! command -v terragrunt &> /dev/null; then
    TG_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | jq -r .tag_name)
    curl -Lo terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/$TG_VERSION/terragrunt_linux_amd64"
    chmod +x terragrunt && sudo mv terragrunt /usr/local/bin/
fi

# Ansible
if ! command -v ansible &> /dev/null; then
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
fi

# --- 6. MULTI-CLOUD CLIs (AWS & AZURE) ---
echo "☁️  Configurando Cloud Management (AWS & Azure)..."

# AWS CLI v2
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip && sudo ./aws/install && rm -rf awscliv2.zip ./aws
fi

# Azure CLI
if ! command -v az &> /dev/null; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

# --- 7. CONFIGURACIÓN DE PRODUCTIVIDAD Y ALIAS (HYGIENE) ---
echo "✍️  Sincronizando perfiles de terminal..."
sed -i '/alias ls=/d' ~/.bashrc
sed -i '/alias cat=/d' ~/.bashrc
sed -i '/alias top=/d' ~/.bashrc

{
    echo "alias ls='eza --icons --group-directories-first'"
    echo "alias cat='batcat --paging=never'"
    echo "alias top='btm'"
    echo "alias tf='terraform'"
    echo "alias tg='terragrunt'"
} >> ~/.bashrc

echo "-------------------------------------------------------"
echo "✅ FASE 0: ENTORNO SRE LISTO Y VALIDADO"
echo "-------------------------------------------------------"
echo "Instrucción: Ejecuta 'source ~/.bashrc' para activar los alias."
