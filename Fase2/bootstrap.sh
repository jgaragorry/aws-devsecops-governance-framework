#!/bin/bash
set -e  # Si cualquier comando falla, el script se detiene inmediatamente

echo "================================================================="
echo "🚀 INICIALIZANDO ENTORNO IAC - SRE MASTER"
echo "================================================================="

# 1. Actualizar repositorios
sudo apt-get update -y

# 2. Instalar dependencias base
sudo apt-get install -y curl gnupg software-properties-common unzip jq

# 3. Docker — instalación idempotente
if ! command -v docker &> /dev/null; then
    echo "🐳 Instalando Docker Engine..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker "$USER"
    echo "✅ Docker instalado. IMPORTANTE: cierra y vuelve a abrir tu terminal."
else
    echo "✅ Docker ya instalado: $(docker --version)"
fi

# 4. Terraform — instalación idempotente
if ! command -v terraform &> /dev/null; then
    echo "💜 Instalando Terraform..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg \
        | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo \
        "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
        https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
        | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update -y && sudo apt-get install terraform -y
else
    echo "✅ Terraform ya instalado: $(terraform --version)"
fi

# 5. Terragrunt — instalación idempotente
if ! command -v terragrunt &> /dev/null; then
    echo "💙 Instalando Terragrunt..."
    TG_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest \
        | jq -r '.tag_name')
    curl -SL \
        "https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_amd64" \
        -o /tmp/terragrunt
    sudo install -m 0755 /tmp/terragrunt /usr/local/bin/terragrunt
    rm /tmp/terragrunt
else
    echo "✅ Terragrunt ya instalado: $(terragrunt --version)"
fi

# 6. Infracost — instalación idempotente
if ! command -v infracost &> /dev/null; then
    echo "💰 Instalando Infracost..."
    curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
else
    echo "✅ Infracost ya instalado: $(infracost --version)"
fi

echo "================================================================="
echo "🎉 ¡SISTEMA BASE LISTO AL 100%!"
echo "================================================================="
