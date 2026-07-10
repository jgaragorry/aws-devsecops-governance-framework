<div align="center">

# 🚀 Lab · Arquitectura Multi-Ambiente Desacoplada

### Tier-2 Topology con Terraform + Terragrunt + Docker

<br/>

![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Terragrunt](https://img.shields.io/badge/Terragrunt-DRY-004088?style=for-the-badge&logo=terragrunt&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Aislado-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Dev](https://img.shields.io/badge/Dev-Puerto_8083-3B82F6?style=for-the-badge)
![Prod](https://img.shields.io/badge/Prod-Puerto_8084-22C55E?style=for-the-badge)

<br/>

> **Objetivo:** Desplegar dos entornos completamente aislados (`dev` y `prod`) con Nginx + PostgreSQL,  
> sin duplicar código — aplicando el principio **DRY** a través de **Terragrunt**.

</div>

---

## 📐 Arquitectura del Sistema

```mermaid
graph TB
    subgraph Internet["🌐 Acceso Externo"]
        SRE(["👤 SRE / Operador"])
    end

    subgraph Host["💻 Máquina Host — localhost"]

        subgraph DEV["🔵 Entorno DEVELOPMENT"]
            direction TB
            WD["🐳 dev-frontend-app\nNginx 1.27.0\n:8083"]
            DD["🐘 dev-postgres-db\nPostgreSQL 15\nRed Interna"]
            WD -- "TCP Interno" --> DD
        end

        subgraph PROD["🟢 Entorno PRODUCTION"]
            direction TB
            WP["🐳 prod-frontend-app\nNginx 1.27.0\n:8084"]
            DP["🐘 prod-postgres-db\nPostgreSQL 16.2\nRed Interna"]
            WP -- "TCP Interno" --> DP
        end

    end

    SRE -- "HTTP :8083" --> WD
    SRE -- "HTTP :8084" --> WP

    style Internet fill:#1e293b,stroke:#64748b,color:#e2e8f0
    style Host    fill:#0f172a,stroke:#475569,color:#e2e8f0
    style DEV     fill:#1e3a5f,stroke:#3b82f6,stroke-width:2px,color:#93c5fd
    style PROD    fill:#14532d,stroke:#22c55e,stroke-width:2px,color:#86efac
    style WD      fill:#1d4ed8,stroke:#93c5fd,color:#ffffff
    style DD      fill:#1d4ed8,stroke:#93c5fd,color:#ffffff
    style WP      fill:#15803d,stroke:#86efac,color:#ffffff
    style DP      fill:#15803d,stroke:#86efac,color:#ffffff
    style SRE     fill:#7c3aed,stroke:#c4b5fd,color:#ffffff
```

> Cada entorno vive en su propia **red Docker aislada** — nunca comparten tráfico interno.

---

## 🗂️ Estructura del Repositorio

```mermaid
graph LR
    ROOT["📁 lab-desacoplado/"]

    ROOT --> MOD["📁 modules/"]
    ROOT --> ENV["📁 environments/"]

    MOD --> STACK["📁 stack-aplicacion/\n◾ El Molde Central"]
    STACK --> VARS["📄 variables.tf\nParámetros de entrada"]
    STACK --> MAIN["📄 main.tf\nLógica declarativa"]

    ENV --> DEV2["📁 dev-stack/\n🔵 Puerto 8083 · PG 15"]
    ENV --> PROD2["📁 prod-stack/\n🟢 Puerto 8084 · PG 16.2"]

    DEV2 --> HCLDEV["📄 terragrunt.hcl"]
    PROD2 --> HCLPROD["📄 terragrunt.hcl"]

    style ROOT  fill:#1e293b,stroke:#64748b,color:#e2e8f0
    style MOD   fill:#312e81,stroke:#818cf8,color:#c7d2fe
    style STACK fill:#312e81,stroke:#818cf8,color:#c7d2fe
    style VARS  fill:#1e1b4b,stroke:#6366f1,color:#a5b4fc
    style MAIN  fill:#1e1b4b,stroke:#6366f1,color:#a5b4fc
    style ENV   fill:#14532d,stroke:#22c55e,color:#86efac
    style DEV2  fill:#1e3a5f,stroke:#3b82f6,color:#93c5fd
    style PROD2 fill:#14532d,stroke:#22c55e,color:#86efac
    style HCLDEV  fill:#1d4ed8,stroke:#93c5fd,color:#fff
    style HCLPROD fill:#15803d,stroke:#86efac,color:#fff
```

---

## ⚡ Flujo de Ejecución

```mermaid
flowchart LR
    A["🧱 Fase 1\nMoldes .tf\nmodules/"]
    B["⚙️ Fase 2\nInputs .hcl\nenvironments/"]
    C["🚀 Fase 3\nterragrunt apply"]
    D["🔍 Fase 4\nAuditoría\ndocker ps"]
    E["🧹 Fase 5\nCierre Controlado\nterragrunt destroy"]

    A --> B --> C --> D --> E

    style A fill:#7B42BC,stroke:#c4b5fd,color:#fff
    style B fill:#004088,stroke:#93c5fd,color:#fff
    style C fill:#15803d,stroke:#86efac,color:#fff
    style D fill:#b45309,stroke:#fcd34d,color:#fff
    style E fill:#991b1b,stroke:#fca5a5,color:#fff
```

---

## 🛠️ Guía de Uso Rápido

### 1️⃣ Desplegar Entorno de Desarrollo

```bash
cd environments/dev-stack/
terragrunt apply -auto-approve
```

### 2️⃣ Desplegar Entorno de Producción

```bash
cd environments/prod-stack/
terragrunt apply -auto-approve
```

### 3️⃣ Verificar Aislamiento

```bash
# Ver contenedores activos con imágenes y puertos
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}"

# Confirmar redes aisladas
docker network ls | grep -E "dev|prod"
```

### 4️⃣ Desmantelamiento Ordenado

> ⚠️ **Destruir en orden descendente** para evitar bloqueos por dependencias compartidas.

```bash
# Primero: Producción
cd environments/prod-stack/
terragrunt destroy -auto-approve

# Después: Desarrollo
cd ../dev-stack/
terragrunt destroy -auto-approve
```

---

## 🛡️ Controles de Seguridad SRE

```mermaid
mindmap
  root(("🔐 SRE\nSecurity"))
    🏷️ Inmutabilidad
      Sin tag :latest
      Versión fija por entorno
      Reproducibilidad garantizada
    🔧 Motor Declarativo
      terraform_binary = terraform
      Sin ambigüedad con OpenTofu
      Fidelidad del proveedor
    🔒 Parcheo Semántico
      Operador ~> 3.0.2
      Parches menores automáticos
      Sin breaking changes
    🔗 Grafo de Dependencias
      depends_on controlado
      DB arriba primero
      Web arriba después
```

---

## 📊 Comparativa de Entornos

| Parámetro            | 🔵 Development          | 🟢 Production           |
|----------------------|-------------------------|-------------------------|
| **Puerto Externo**   | `8083`                  | `8084`                  |
| **Frontend**         | Nginx `1.27.0`          | Nginx `1.27.0`          |
| **Base de Datos**    | PostgreSQL `15`         | PostgreSQL `16.2`       |
| **Red Docker**       | `dev-network` (aislada) | `prod-network` (aislada)|
| **Prefijo recursos** | `dev-`                  | `prod-`                 |
| **Código Terraform** | ♻️ Módulo compartido    | ♻️ Módulo compartido    |

---

## 💡 Filosofía DRY en Acción

```mermaid
graph TD
    TF["🧱 Un solo módulo Terraform\nmodules/stack-aplicacion/"]

    TF -->|"Variables Dev\nterragrunt.hcl"| DEVENV["🔵 dev-stack\nInstancia Development"]
    TF -->|"Variables Prod\nterragrunt.hcl"| PRODENV["🟢 prod-stack\nInstancia Production"]

    DEVENV --> R1["Puerto 8083\nPostgreSQL 15"]
    PRODENV --> R2["Puerto 8084\nPostgreSQL 16.2"]

    style TF      fill:#7B42BC,stroke:#c4b5fd,color:#fff
    style DEVENV  fill:#1e3a5f,stroke:#3b82f6,color:#93c5fd
    style PRODENV fill:#14532d,stroke:#22c55e,color:#86efac
    style R1      fill:#1d4ed8,stroke:#93c5fd,color:#fff
    style R2      fill:#15803d,stroke:#86efac,color:#fff
```

> Un único módulo `main.tf` → N entornos distintos. **Cero duplicación de código.**

---

<div align="center">

**Módulo 2 — Orquestación Avanzada Multi-Tier**

![Status](https://img.shields.io/badge/Lab-Completado-22C55E?style=flat-square)
![DRY](https://img.shields.io/badge/Principio-DRY-7B42BC?style=flat-square)
![IaC](https://img.shields.io/badge/IaC-Terraform%20%2B%20Terragrunt-004088?style=flat-square)

</div>

