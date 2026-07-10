# 🚀 RUNBOOK: Despliegue de Infraestructura Local con OpenTofu

[![OpenTofu](https://img.shields.io/badge/OpenTofu-v1.8.8-7B42BC?style=for-the-badge&logo=opentofu&logoColor=white)](https://opentofu.org)
[![Ubuntu](https://img.shields.io/badge/WSL-Ubuntu_24.04_LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Docker](https://img.shields.io/badge/Provider-Docker_v4.4.0-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docker.com)
[![Status](https://img.shields.io/badge/Status-Production_Ready-22C55E?style=for-the-badge&logo=checkmarx&logoColor=white)]()

> **Objetivo:** Procedimiento estándar para instalar, configurar y administrar infraestructura local con OpenTofu siguiendo buenas prácticas SRE — inmutabilidad, aislamiento y reproducibilidad garantizados.

---

## 📐 Arquitectura General

```mermaid
flowchart LR
    classDef tool fill:#7B42BC,stroke:#5B2D9C,color:#fff,rx:8
    classDef file fill:#2496ED,stroke:#1A6FB5,color:#fff,rx:8
    classDef action fill:#22C55E,stroke:#16A34A,color:#fff,rx:8
    classDef output fill:#F59E0B,stroke:#D97706,color:#fff,rx:8

    A(["🔧 Script\nIdempotente"]):::tool -->|instala| B(["⚙️ Binario\nOpenTofu v1.8.8"]):::tool
    B --> C(["📁 Estructura\nMulti-archivo .tf"]):::file
    C --> D(["🔄 tofu init"]):::action
    D --> E(["✅ fmt · validate"]):::action
    E --> F(["📋 tofu plan\n-out=.tfplan"]):::action
    F --> G(["🚀 tofu apply"]):::action
    G --> H(["🐳 docker_container\nalpine:3.20.0"]):::output
```

---

## ✅ Prerrequisitos

```mermaid
flowchart LR
    classDef check fill:#22C55E,stroke:#16A34A,color:#fff
    classDef warn fill:#F59E0B,stroke:#D97706,color:#fff

    P1(["🐳 Docker Engine\nactivo en WSL"]):::check
    P2(["🌐 Acceso\na Internet"]):::check
    P3(["👤 Permisos\nsudo"]):::check

    P1 & P2 & P3 --> OK(["🟢 Listo para\ncontinuar"]):::check
```

> Verificar Docker activo: `sudo service docker start`

---

## 📋 Flujo de Pasos

```mermaid
flowchart TD
    classDef step fill:#7B42BC,stroke:#5B2D9C,color:#fff,rx:6
    classDef cmd fill:#1E293B,stroke:#475569,color:#94A3B8,rx:4,font-family:monospace
    classDef ok fill:#22C55E,stroke:#16A34A,color:#fff,rx:6

    S1(["1️⃣ Instalar OpenTofu"]):::step --> S2(["2️⃣ Crear entorno aislado"]):::step
    S2 --> S3(["3️⃣ Definir archivos .tf"]):::step
    S3 --> S4(["4️⃣ tofu init"]):::step
    S4 --> S5(["5️⃣ fmt + validate"]):::step
    S5 --> S6(["6️⃣ tofu plan"]):::step
    S6 --> S7(["7️⃣ tofu apply"]):::step
    S7 --> S8(["8️⃣ Verificar outputs"]):::step
    S8 --> DONE(["✅ Infraestructura\nDesplegada"]):::ok
```

---

## 🔧 PASO 1 — Instalación Idempotente de OpenTofu

> Descarga directa desde GitHub Releases para evitar fallas de redirección CDN o índices APT desactualizados.

```bash
cat << 'EOF' > instalar_tofu_manual.sh
#!/bin/bash
set -e

ARCH=$(uname -m)
[ "$ARCH" = "x86_64" ]  && TOFU_ARCH="amd64"
[ "$ARCH" = "aarch64" ] && TOFU_ARCH="arm64"

VERSION="1.8.8"
FILENAME="tofu_${VERSION}_linux_${TOFU_ARCH}.tar.gz"
URL="https://github.com/opentofu/opentofu/releases/download/v${VERSION}/${FILENAME}"

rm -f /tmp/tofu_*
curl -L --fail -o "/tmp/${FILENAME}" "${URL}"
cd /tmp && tar -xzf "${FILENAME}" tofu
sudo mv tofu /usr/local/bin/tofu && sudo chmod +x /usr/local/bin/tofu

tofu --version && echo "✅ OpenTofu instalado con éxito!"
EOF

chmod +x instalar_tofu_manual.sh && ./instalar_tofu_manual.sh
```

---

## 📁 PASO 2 — Entorno Aislado de Trabajo

```bash
mkdir -p ~/sre-linux-mastery/Fase2/iac-mastery/laboratorio-local/ejercicio-opentofu/lab-tofu-profesional
cd ~/sre-linux-mastery/Fase2/iac-mastery/laboratorio-local/ejercicio-opentofu/lab-tofu-profesional
```

---

## 🗂️ PASO 3 — Estructura Modular de Archivos

```mermaid
block-beta
    columns 5
    A["📄 providers.tf\n─────────────\nBackend +\nVersiones fijas"]:1
    B["📄 variables.tf\n─────────────\nTipado de\nparámetros"]:1
    C["📄 terraform.tfvars\n─────────────\nValores de\nproducción"]:1
    D["📄 main.tf\n─────────────\nRecursos\nDocker"]:1
    E["📄 outputs.tf\n─────────────\nSalidas de\nla API"]:1

    style A fill:#7B42BC,stroke:#5B2D9C,color:#fff
    style B fill:#2496ED,stroke:#1A6FB5,color:#fff
    style C fill:#F59E0B,stroke:#D97706,color:#fff
    style D fill:#22C55E,stroke:#16A34A,color:#fff
    style E fill:#EF4444,stroke:#DC2626,color:#fff
```

### 3.1 `providers.tf`
```hcl
terraform {
  required_version = ">= 1.8.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.4.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
```

### 3.2 `variables.tf`
```hcl
variable "nombre_contenedor" {
  type        = string
  description = "Nombre descriptivo del contenedor en Docker"
}

variable "version_imagen_alpine" {
  type        = string
  description = "Versión fija de Alpine para garantizar inmutabilidad"
}
```

### 3.3 `terraform.tfvars`
```hcl
nombre_contenedor     = "servidor_seguro_alpine"
version_imagen_alpine = "3.20.0"
```

### 3.4 `main.tf`
```hcl
resource "docker_image" "alpine_image" {
  name         = "alpine:${var.version_imagen_alpine}"
  keep_locally = false
}

resource "docker_container" "alpine_container" {
  image   = docker_image.alpine_image.image_id
  name    = var.nombre_contenedor
  command = ["tail", "-f", "/dev/null"]
}
```

### 3.5 `outputs.tf`
```hcl
output "contenedor_id" {
  value       = docker_container.alpine_container.id
  description = "ID único generado por Docker"
}

output "nombre_contenedor_creado" {
  value       = docker_container.alpine_container.name
  description = "Nombre oficial asignado al contenedor"
}
```

---

## 🔄 PASOS 4–7 — Ciclo de Vida IaC

```mermaid
sequenceDiagram
    autonumber
    actor SRE
    participant TF as 🟣 OpenTofu
    participant DP as 🐳 Docker Provider
    participant DC as 🐋 Docker Engine

    SRE->>TF: tofu init
    TF->>DP: Descarga plugin kreuzwerker/docker v4.4.0
    DP-->>TF: ✅ Plugin instalado + firma verificada

    SRE->>TF: tofu fmt & validate
    TF-->>SRE: ✅ Sintaxis y lógica correctas

    SRE->>TF: tofu plan -out=despliegue_seguro.tfplan
    TF-->>SRE: 📋 Plan generado (2 recursos a crear)

    SRE->>TF: tofu apply "despliegue_seguro.tfplan"
    TF->>DC: Crear imagen alpine:3.20.0
    TF->>DC: Crear contenedor servidor_seguro_alpine
    DC-->>TF: ✅ Contenedor running
    TF-->>SRE: 🚀 Apply complete! Outputs disponibles
```

```bash
# Init
tofu init

# Quality Gate
tofu fmt && tofu validate

# Plan cerrado (práctica enterprise)
tofu plan -out=despliegue_seguro.tfplan

# Apply
tofu apply "despliegue_seguro.tfplan"
```

---

## 🔍 PASO 8 — Verificación Operativa

```bash
# Outputs de OpenTofu
tofu output

# Estado real en Docker
docker ps --filter "name=servidor_seguro_alpine"
```

**Salida esperada:**

```
contenedor_id              = "a3f9b..."
nombre_contenedor_creado   = "servidor_seguro_alpine"
```

---

## 🔥 Plan de Contingencia — Rollback

```mermaid
flowchart LR
    classDef danger fill:#EF4444,stroke:#DC2626,color:#fff,rx:6
    classDef auto   fill:#F59E0B,stroke:#D97706,color:#fff,rx:6
    classDef result fill:#1E293B,stroke:#475569,color:#94A3B8,rx:6

    A(["⚠️ Necesito\neliminar recursos"])
    B(["🛡️ Entorno\nProducción\ntofu destroy"]):::danger
    C(["⚡ Pipeline CI/CD\ntofu destroy\n-auto-approve"]):::auto
    D(["💀 Todos los recursos\neliminados"]):::result

    A --> B & C --> D
```

```bash
# 🛡️ Modo Seguro — pide confirmación manual
tofu destroy

# ⚡ Modo Automatizado — sin interacción (CI/CD únicamente)
tofu destroy -auto-approve
```

> ⚠️ **Usar `-auto-approve` exclusivamente en pipelines CI/CD o entornos de laboratorio. Nunca en producción manual.**

---

## 📊 Resumen de Comandos

| # | Comando | Propósito |
|---|---------|-----------|
| 1 | `tofu init` | Inicializa backend y descarga providers |
| 2 | `tofu fmt` | Formatea archivos HCL automáticamente |
| 3 | `tofu validate` | Valida consistencia lógica |
| 4 | `tofu plan -out=*.tfplan` | Genera plan reproducible |
| 5 | `tofu apply "*.tfplan"` | Ejecuta el plan congelado |
| 6 | `tofu output` | Muestra salidas definidas |
| 7 | `tofu destroy` | Destruye todos los recursos |

---

*Runbook mantenido bajo estándar SRE · OpenTofu v1.8.8 · Docker Provider v4.4.0*

