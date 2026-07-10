# 📋 Phase 0: Onboarding & Setup

<div align="center">

![Phase](https://img.shields.io/badge/Phase-0-lightgrey?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Required%20Foundation-27ae60?style=for-the-badge)
![Duration](https://img.shields.io/badge/Duration-1--2%20Weeks-3498db?style=for-the-badge)
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-f39c12?style=for-the-badge)

---

**La base sólida determina el éxito de toda la especialización**

</div>

---

## 📖 Tabla de Contenidos

- [🎯 Objetivos](#-objetivos)
- [📋 Requisitos Previos](#-requisitos-previos)
- [⚡ Quick Start](#-quick-start)
- [📦 Archivos de Esta Fase](#-archivos-de-esta-fase)
- [💡 ¿Por qué Ubuntu 24.04 y Qué es Idempotencia?](#-por-qué-ubuntu-2404-y-qué-es-idempotencia)
- [🔧 Instalación Paso a Paso](#-instalación-paso-a-paso)
- [✅ Validación de Requisitos](#-validación-de-requisitos)
- [🐛 Troubleshooting](#-troubleshooting)
- [➡️ Siguiente: Phase 1](#-siguiente-phase-1)

---

## 💡 ¿Por qué Ubuntu 24.04 y Qué es Idempotencia?

### **¿Por qué específicamente Ubuntu 24.04 LTS?**

Elegimos Ubuntu 24.04 LTS por **razones técnicas y empresariales**:

| Razón | Impacto |
|-------|---------|
| **LTS hasta 2029** | Soporte de 5 años garantizado | 
| **Última generación** | Kernel 6.8+, systemd 255+, toolchain moderno |
| **PEP 668** | Enseña a trabajar con externally-managed environments (realidad productiva) |
| **Estándar Enterprise** | Major cloud providers lo soportan como "stable" |
| **Repositorio maduro** | Versiones de Terraform, Ansible, Docker ya probadas |

**Si usas otra versión:**
- Pueden surgir diferencias en paths, comandos o versiones
- El script de bootstrap validará tu OS y alertará
- No podemos garantizar compatibilidad 100% en todas las herramientas

### **¿Qué es Idempotencia?**

En SRE, **idempotencia** es un concepto crítico:

> **Idempotencia = Ejecutar 1 vez o 100 veces = mismo resultado final**

```bash
# Ejemplo NO idempotente (problemático):
echo "nueva linea" >> ~/.bashrc  # Ejecutar 2 veces = 2 líneas duplicadas ❌

# Ejemplo idempotente (correcto):
grep -q "nueva linea" ~/.bashrc || echo "nueva linea" >> ~/.bashrc  # Seguro ejecutar N veces ✓
```

**El script `sre_phase0_bootstrap.sh` es idempotente porque:**

✅ Verifica si algo ya está instalado antes de instalarlo nuevamente
✅ Si la ejecución se interrumpe, puedes ejecutarlo nuevamente sin miedo
✅ No crea duplicados o configuraciones conflictivas
✅ Es **production-ready** (es decir, apto para usar en servidores reales)

Esto es lo que hace que sea diferente de un simple "bash script". Es una característica de SRE.

---

Al completar esta fase tendrás:

```
✅ Entorno Linux completamente configurado (Ubuntu 24.04 LTS)
✅ Herramientas modernas instaladas (Rust, Go, Node.js)
✅ Git y GitHub configurados correctamente
✅ Docker y Docker Compose listos para usar
✅ Herramientas CLI avanzadas (jq, yq, aws-cli, azure-cli)
✅ Editor de código (VSCode o preferencia personal)
✅ Capacidad de ejecutar scripts idempotentes
✅ Entorno de desarrollo de "primer nivel"
```

---

## 📋 Requisitos Previos

### Hardware Mínimo

| Recurso | Mínimo | Recomendado |
|---------|--------|-------------|
| **CPU** | 2 cores | 4+ cores |
| **RAM** | 4GB | 8GB+ |
| **Almacenamiento** | 30GB | 50GB+ SSD |
| **Internet** | 5 Mbps | 10+ Mbps |

### Software Requerido

```bash
# Verificar antes de comenzar:
✓ Ubuntu 24.04 LTS (u otro Linux moderno)
✓ Acceso root o sudo
✓ Conexión a internet estable
✓ Git 2.40+ (instalado o por instalar)
```

### Conocimientos Mínimos

- Familiaridad básica con terminal Linux
- Conceptos fundamentales de networking (IP, puertos, DNS)
- Noción básica de permisos en Linux (rwx)
- No se requiere experiencia previa en scripting

---

## ⚡ Quick Start

### **Opción 1: Bootstrap Automático (Recomendado para la mayoría)**

Si prefieres **velocidad** y confianza en el proceso:

```bash
# 1. Clona el repositorio
git clone https://github.com/softraincorp/sre-linux-specialization.git
cd sre-linux-specialization/phase0-onboarding

# 2. Ejecuta el bootstrap (requiere sudo)
bash sre_phase0_bootstrap.sh

# Este script es IDEMPOTENTE:
# ✓ Puedes ejecutarlo varias veces con total seguridad
# ✓ Valida que tengas Ubuntu 24.04 LTS antes de continuar
# ✓ Salta pasos ya instalados
# ✓ Maneja automáticamente errores y reintentos
# ✓ Incluye todas las versiones estables recomendadas

# 3. Sigue las instrucciones en pantalla
# 4. Valida la instalación
bash environment_check.sh
```

**⏱️ Tiempo:** ~1-2 horas (depende de tu conexión y hardware)

### **Opción 2: Setup Manual Paso a Paso (Para aprender el "cómo" y el "por qué")**

Si prefieres **máximo control** y entender cada paso:

```bash
# Sigue la guía detallada en esta sección:
# → [Instalación Paso a Paso](#-instalación-paso-a-paso)

# Este camino es más lento pero mucho más educativo.
# Ideal si eres nuevo en Linux o quieres entender la plomería.
```

**⏱️ Tiempo:** ~3-4 horas (incluye lectura y comprensión)

### **Opción 3: Híbrida (Recomendado si tienes experiencia)**

```bash
# Ejecuta el script automático
bash sre_phase0_bootstrap.sh

# Pero antes, lee estas secciones para entender qué hace:
# → [Instalación Paso a Paso](#-instalación-paso-a-paso)
# → [Validación de Requisitos](#-validación-de-requisitos)
```

---

**🎯 Para la mayoría: Usa Opción 1 (Bootstrap)**. 
Es como la diferencia entre viajar en auto vs en bicicleta. Ambos te llevan al mismo lugar, pero uno es más práctico.

---

## 📦 Archivos de Esta Fase

```
phase0-onboarding/
│
├── README.md                     # ← Estás aquí
├── sre_phase0_bootstrap.sh       # Script de instalación automática
├── environment_check.sh          # Validación del entorno
├── tools_installation.sh         # Setup de herramientas modernas
├── config_templates/             # Archivos de configuración base
│   ├── .bashrc_sre_additions
│   ├── .gitconfig_template
│   └── docker_daemon.json
└── docs/
    ├── detailed_setup.md         # Guía detallada de instalación
    ├── troubleshooting.md        # Solución de problemas comunes
    └── tools_guide.md            # Guía de cada herramienta
```

---

## 🔧 Instalación Paso a Paso

### **Paso 1: Actualizar el Sistema**

```bash
# Actualizar repositorios
sudo apt update
sudo apt upgrade -y

# Instalar build essentials
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    htop \
    net-tools
```

### **Paso 2: Instalar Rust**

```bash
# Descargar e instalar Rust (directorio $HOME/.cargo)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Aplicar los cambios
source $HOME/.cargo/env

# Verificar instalación
rustc --version
cargo --version
```

### **Paso 3: Instalar Go**

```bash
# Descargar Go 1.21+ (ajusta la versión según sea necesario)
curl -L https://go.dev/dl/go1.21.0.linux-amd64.tar.gz | sudo tar -C /usr/local -xz

# Agregar a PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verificar instalación
go version
```

### **Paso 4: Instalar Node.js**

```bash
# Usar NodeSource para obtener la versión LTS más reciente
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verificar instalación
node --version
npm --version
```

### **Paso 5: Instalar Docker**

```bash
# Agregar repositorio oficial de Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Agregar tu usuario al grupo docker
sudo usermod -aG docker $USER

# Aplicar grupo sin reiniciar
newgrp docker

# Verificar instalación
docker --version
docker run hello-world
```

⚠️ **Nota para WSL2 (Windows Subsystem for Linux 2):**

Si usas **Windows con WSL2 y Docker Desktop**, sigue estos pasos:

1. Instala Docker Desktop desde [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. En Docker Desktop Settings → Resources → WSL Integration
3. Activa la integración con tu distribución Ubuntu 24.04
4. Abre una terminal WSL2 y verifica:

```bash
docker --version
docker run hello-world
```

Si aún así necesitas instalar Docker dentro de WSL2, sigue el comando anterior en tu distribución.



### **Paso 6: Instalar Docker Compose**

```bash
# Docker Compose v2 viene con Docker, pero si necesitas instalarlo explícitamente:
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalación
docker-compose --version
```

### **Paso 7: Instalar Terraform & Terragrunt**

**Opción A: Via APT (Recomendado - Más fácil mantenimiento)**

```bash
# Agregar repositorio oficial de HashiCorp
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Actualizar y instalar
sudo apt update
sudo apt install -y terraform

# Instalar Terragrunt (via GitHub releases)
TERRAGRUNT_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep tag_name | cut -d '"' -f 4)
sudo curl -L https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
    -o /usr/local/bin/terragrunt
sudo chmod +x /usr/local/bin/terragrunt

# Verificar instalación
terraform --version
terragrunt --version
```

**Opción B: Manual (Si prefieres máximo control)**

```bash
# Descargar la última versión estable desde el repositorio oficial
TERRAFORM_VERSION=$(curl -s https://api.releases.hashicorp.com/v1/releases/terraform | jq -r '.releases[0].version')
curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    -o /tmp/terraform.zip
unzip /tmp/terraform.zip
sudo mv terraform /usr/local/bin/
rm /tmp/terraform.zip

# Verificar
terraform --version
```

⚠️ **Ventaja del Método A:** Las actualizaciones se manejan automáticamente con `apt update && apt upgrade`. Ideal para producción.

### **Paso 8: Instalar Ansible**

**Opción A: Via APT (Recomendado - Sin problemas de PEP 668)**

```bash
# Agregar PPA oficial de Ansible
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Instalar Ansible
sudo apt install -y ansible

# Verificar instalación
ansible --version
```

⚠️ **¿Por qué no `pip3 install ansible`?**

Ubuntu 24.04 implementa **PEP 668** (Externally-Managed-Environment), que previene instalar paquetes Python globales con `pip` para evitar conflictos con el sistema. Usar el PPA oficial es la forma "limpia" y recomendada.

**Opción B: Via pip (Si realmente lo necesitas)**

```bash
# Solo si necesitas una versión específica no disponible en APT
python3 -m venv ~/ansible-env
source ~/ansible-env/bin/activate
pip install ansible

# Para usarlo, siempre activa el entorno:
source ~/ansible-env/bin/activate
```



### **Paso 9: Instalar Herramientas CLI Avanzadas**

```bash
# jq (procesador JSON)
sudo apt install -y jq

# yq (procesador YAML)
pip3 install yq

# AWS CLI
pip3 install awscli

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# kubectl (cliente Kubernetes)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Helm (gestor de paquetes Kubernetes)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verificar instalaciones
jq --version
yq --version
aws --version
az --version
kubectl version --client
helm version
```

### **Paso 10: Configurar Git**

```bash
# Configuración básica
git config --global user.name "Tu Nombre"
git config --global user.email "tu.email@example.com"

# Configurar SSH (opcional pero recomendado)
ssh-keygen -t ed25519 -C "tu.email@example.com"
cat ~/.ssh/id_ed25519.pub  # Copiar a GitHub

# Configurar credenciales (token personal)
git config --global credential.helper store
```

### **Paso 11: Instalar VSCode (Opcional)**

```bash
# Descargar desde repositorio Snap (más rápido)
sudo snap install code --classic

# O instalar manualmente desde el sitio oficial
# https://code.visualstudio.com/
```

---

## ✅ Validación de Requisitos

### **Script de Validación Automática**

```bash
# Ejecuta este script para validar todo
bash environment_check.sh
```

### **Validación Manual**

```bash
# Verificar versiones de herramientas principales
echo "=== Sistema Operativo ==="
lsb_release -a

echo "=== Git ==="
git --version

echo "=== Rust ==="
rustc --version

echo "=== Go ==="
go version

echo "=== Node.js ==="
node --version && npm --version

echo "=== Docker ==="
docker --version && docker-compose --version

echo "=== Terraform & Terragrunt ==="
terraform --version && terragrunt --version

echo "=== Ansible ==="
ansible --version

echo "=== CLI Tools ==="
jq --version
yq --version
aws --version
az --version
kubectl version --client
helm version

echo "=== Acceso a Docker (sin sudo) ==="
docker run hello-world
```

### **Checklist de Validación**

Marca cada ítem según sea completado:

```
Validación de Fase 0
====================

Requisitos Previos:
☐ Ubuntu 24.04 LTS o compatible
☐ Acceso sudo/root
☐ Conexión a internet estable
☐ Mínimo 30GB de almacenamiento libre

Instalaciones Completadas:
☐ Git 2.40+
☐ Rust (latest stable)
☐ Go 1.21+
☐ Node.js 20+
☐ Docker & Docker Compose
☐ Terraform & Terragrunt
☐ Ansible
☐ kubectl & Helm
☐ jq, yq, aws-cli, azure-cli

Configuración:
☐ Git configurado (user.name, user.email)
☐ SSH key agregada a GitHub
☐ Docker funciona sin sudo
☐ Acceso a AWS/Azure CLI

Validación Final:
☐ Todos los comandos --version funcionan
☐ Docker run hello-world sin errores
☐ Script environment_check.sh = 100% ✓
```

---

## 🐛 Troubleshooting

### Problema: "Permiso denegado" al ejecutar scripts

```bash
# Solución: Dar permisos de ejecución
chmod +x sre_phase0_bootstrap.sh
chmod +x environment_check.sh
bash sre_phase0_bootstrap.sh
```

### Problema: Error "externally-managed-environment" al instalar con pip

**Error típico:**
```
error: externally-managed-environment
× This environment is externally managed
```

**Solución:**
```bash
# NO HAGAS ESTO (es lo que genera el error):
pip3 install ansible

# HAZ ESTO EN SU LUGAR:
sudo apt install -y ansible
```

Este error ocurre en Ubuntu 24.04 porque implementa **PEP 668**, que protege el Python del sistema. Usa `apt` en su lugar (como se recomienda en el Paso 8).

### Problema: "No se encuentra comando" después de instalar

```bash
# Solución: Recargar la variable PATH
source ~/.bashrc
# O reinicia la terminal completa (ctrl+d y abre una nueva)

# Si persiste, verifica la instalación
which rustc
which go
which docker
which terraform
which ansible
```

Si `which` no encuentra el comando, revisa el paso de instalación. Puede que no se haya completado correctamente.

### Problema: Docker requiere sudo

```bash
# Solución: Agregar usuario al grupo docker
sudo usermod -aG docker $USER
newgrp docker  # Aplica cambios sin reiniciar

# Verifica:
docker run hello-world  # Sin sudo

# Si aún requiere sudo tras newgrp, reinicia tu sesión:
# - Cierra la terminal (ctrl+d)
# - Abre una nueva terminal
# - Intenta nuevamente
```

### Problema: Falta espacio en disco

```bash
# Ver uso de disco
df -h

# Limpiar paquetes no usados
sudo apt autoremove -y
sudo apt clean

# Ver qué ocupa más espacio
du -sh ~/* | sort -rh

# Limpiar imágenes Docker viejas (¡CUIDADO! elimina imágenes no usadas)
docker image prune -a

# Limpiar volúmenes y caché de Docker
docker system prune -a
```

### Problema: Error de conectividad durante descargas

```bash
# Verificar conexión DNS
nslookup google.com
ping google.com

# Cambiar repositorios a mirror más rápido si tienes latencia alta
# (ejemplo para Latinoamérica o región específica)
sudo sed -i 's/archive.ubuntu.com/mirror.example.com/g' /etc/apt/sources.list

# Limpiar caché de apt e intentar nuevamente
sudo apt clean
sudo apt update
```

### Problema: WSL2 - Docker no funciona

```bash
# Si usas WSL2 en Windows:
# 1. Asegúrate de tener Docker Desktop instalado (no solo Docker en WSL)
# 2. Abre Docker Desktop y ve a Settings > Resources > WSL Integration
# 3. Activa tu distribución Ubuntu 24.04
# 4. Reinicia WSL: wsl --shutdown (en PowerShell)
# 5. Abre terminal WSL nuevamente y prueba:
docker --version
docker run hello-world
```

### Problema: Versión diferente a la esperada

```bash
# Si alguna herramienta instaló una versión inesperada:
tool_name --version

# Actualizar a la última:
sudo apt update && sudo apt upgrade

# Si necesitas una versión específica, sigue el paso manual de esa herramienta
# Ejemplo: Terraform con descarga manual en lugar de APT
```

### Problema: El script bootstrap se interrumpe a mitad

```bash
# No hay problema. El script es IDEMPOTENTE.
# Significa que puedes ejecutarlo nuevamente y:
# - Saltará lo que ya está instalado
# - Continuará desde donde se detuvo
bash sre_phase0_bootstrap.sh
```

**Para más problemas específicos**, consulta [docs/troubleshooting.md](./docs/troubleshooting.md)

---

## 📚 Recursos Adicionales

- **Bash Scripting:** [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- **Git Workflow:** [GitHub Flow](https://guides.github.com/introduction/flow/)
- **Docker Best Practices:** [Official Docker Guide](https://docs.docker.com/)
- **Terraform Documentation:** [Terraform Docs](https://www.terraform.io/docs)
- **Ansible Playbooks:** [Ansible Documentation](https://docs.ansible.com/)

---

## ⏱️ Tiempo Estimado

> 🎯 **Tiempo Total: Un día completo de inmersión (4-8 horas depending en experiencia)**

| Actividad | Duración | Notas |
|-----------|----------|-------|
| Actualizar sistema | 10-15 min | Puede ser más si hay muchas actualizaciones |
| Instalar Rust | 5-10 min | Descarga ~200MB, compilación local |
| Instalar Go | 5 min | Rápido |
| Instalar Node.js | 5 min | Rápido |
| Instalar Docker | 10-15 min | Puede necesitar reboot en algunos sistemas |
| Instalar Terraform | 5-10 min | Más rápido con APT que con descarga manual |
| Instalar Ansible | 5-10 min | Con PPA: muy rápido |
| Instalar CLI Tools | 15-20 min | kubectl, helm, jq, yq, aws-cli, azure-cli |
| Configurar Git + SSH | 10-15 min | Incluye generación de llaves SSH |
| Validación completa | 20-30 min | Ejecutar todos los tests y verificaciones |
| **TOTAL (Sin interrupciones)** | **~85-120 minutos** | ~1.5-2 horas |

### ⚡ En la Realidad (Primer Día):

Este proceso será más cercano a **4-8 horas** cuando incluyes:

- ✓ Leer la documentación con detalle
- ✓ Troubleshooting de problemas únicos a tu setup
- ✓ Configuración de SSH y GitHub
- ✓ Posibles reinicios del sistema
- ✓ Descargas lentas (según tu ISP)
- ✓ Comprensión de cada paso (no es "correr y listo")

**Recomendación:** Dedica **una tarde completa** a esta fase. No es una "tarea de 20 minutos". Es tu **inversión en una base sólida** para toda la especialización.

---

## ➡️ Siguiente: Phase 1

Una vez completada esta fase:

1. ✅ Valida con `environment_check.sh`
2. ✅ Completa el checklist anterior
3. ✅ Crea un commit en tu repositorio
4. ⏭️ **Avanza a [Phase 1: Linux Deep Dive](../phase1-linux-core/README.md)**

---

<div align="center">

### Estás listo para dominar Linux y SRE 🚀

**Próxima parada: Linux Deep Dive (Phase 1)**

![Progress](https://img.shields.io/badge/Progress-Phase%200%2F6-blue?style=flat-square)

</div>

