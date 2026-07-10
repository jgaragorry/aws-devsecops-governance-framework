#!/usr/bin/env bash

# Script de aprovisionamiento idempotente para Laboratorio IaC (WSL Ubuntu 24.04 LTS)
set -euo pipefail

# Colores para salida organizada
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Iniciando verificación y preconfiguración del entorno IaC ===${NC}"

# 1. Actualización e instalación de paquetes base obligatorios
echo -e "${BLUE}[1/5] Actualizando paquetes del sistema...${NC}"
sudo apt update -qq
sudo apt install -y -qq curl gnupg lsb-release ca-certificates unzip git

# 2. Instalación Idempotente de Docker Engine Nativo
echo -e "${BLUE}[2/5] Verificando Docker Engine...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker no detectado. Instalando versión nativa estable...${NC}"
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -qq
    sudo apt install -y -qq docker-ce docker-ce-cli containerd.io
else
    echo -e "${GREEN}✔ Docker ya se encuentra instalado.${NC}"
fi

# Configuración del grupo Docker para el usuario actual (Evita usar sudo)
if ! groups "$USER" | grep &> /dev/null "\bdocker\b"; then
    echo -e "${YELLOW}Añadiendo al usuario $USER al grupo docker...${NC}"
    sudo usermod -aG docker "$USER"
    echo -e "${YELLOW}Nota: Para aplicar los cambios de Docker sin reiniciar WSL, ejecute 'newgrp docker' al finalizar.${NC}"
else
    echo -e "${GREEN}✔ El usuario ya pertenece al grupo docker.${NC}"
fi

# Asegurar que el servicio de Docker esté corriendo en WSL
if ! sudo service docker status &> /dev/null; then
    echo -e "${YELLOW}Iniciando el demonio de Docker...${NC}"
    sudo service docker start
else
    echo -e "${GREEN}✔ El servicio Docker ya está en ejecución.${NC}"
fi

# 3. Instalación Idempotente de Terraform
echo -e "${BLUE}[3/5] Verificando Terraform...${NC}"
if ! command -v terraform &> /dev/null; then
    echo -e "${YELLOW}Terraform no detectado. Configurando repositorio de HashiCorp...${NC}"
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update -qq && sudo apt install -y -qq terraform
else
    echo -e "${GREEN}✔ Terraform ya se encuentra instalado ($(terraform version | head -n1)).${NC}"
fi

# 4. Instalación Idempotente de Terragrunt
echo -e "${BLUE}[4/5] Verificando Terragrunt...${NC}"
if ! command -v terragrunt &> /dev/null; then
    echo -e "${YELLOW}Terragrunt no detectado. Descargando última versión estable de GitHub...${NC}"
    TG_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -SL "https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_amd64" -o terragrunt
    chmod +x terragrunt
    sudo mv terragrunt /usr/local/bin/terragrunt
else
    echo -e "${GREEN}✔ Terragrunt ya se encuentra instalado ($(terragrunt --version)).${NC}"
fi

# 5. Instalación Idempotente de Infracost
echo -e "${BLUE}[5/5] Verificando Infracost...${NC}"
if ! command -v infracost &> /dev/null; then
    echo -e "${YELLOW}Infracost no detectado. Instalando CLI...${NC}"
    curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
    echo -e "${YELLOW}Por favor, ejecute 'infracost auth login' si es la primera vez que lo usa para activar su API Key gratis.${NC}"
else
    echo -e "${GREEN}✔ Infracost ya se encuentra instalado ($(infracost --version | head -n1)).${NC}"
fi

echo -e "${GREEN}=== ¡Entorno verificado y listo para operar con éxito! ===${NC}"
