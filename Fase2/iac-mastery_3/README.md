<div align="center">

# 🏗️ Arquitectura Multi-Ambiente Desacoplada
### *Tier-2 Topology · Terraform + Terragrunt · DRY Infrastructure*

<br/>

[![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Terragrunt](https://img.shields.io/badge/Terragrunt-0.55%2B-004088?style=for-the-badge&logo=gruntwork&logoColor=white)](https://terragrunt.gruntwork.io/)
[![Docker](https://img.shields.io/badge/Docker-Contenedores-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Nginx](https://img.shields.io/badge/Nginx-1.27.0-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15%20%7C%2016.2-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Ambientes](https://img.shields.io/badge/Ambientes-Dev_%7C_Prod-22C55E?style=for-the-badge&logo=github-actions&logoColor=white)]()
[![DRY](https://img.shields.io/badge/Principio-DRY-F59E0B?style=for-the-badge&logo=abstract&logoColor=white)]()
[![SRE](https://img.shields.io/badge/Disciplina-SRE-D9534F?style=for-the-badge&logo=google&logoColor=white)]()

<br/>

> **Laboratorio práctico de infraestructura reproducible**: dos entornos completamente aislados,  
> un único módulo base, cero duplicación de código.

</div>

---

## 🎯 ¿Qué construye este laboratorio?

Este proyecto demuestra la implementación de una **topología Tier-2** donde cada ambiente (`development` y `production`) despliega de forma **completamente independiente**:

| Capa | Componente | Dev | Prod |
|------|-----------|-----|------|
| 🌐 **Frontend** | Nginx (Web Server) | `1.27.0` · Puerto `8083` | `1.27.0` · Puerto `8084` |
| 🐘 **Base de Datos** | PostgreSQL (RDBMS) | `15` | `16.2` |
| 🔗 **Red** | Docker Network aislada | `dev-network` | `prod-network` |

La magia reside en que **un solo módulo Terraform** alimenta ambos mundos, diferenciados únicamente por variables de Terragrunt.

---

## 🗺️ Arquitectura del Sistema

```mermaid
%%{init: {'theme': 'dark', 'themeVariables': {'primaryColor': '#7B42BC', 'primaryTextColor': '#fff', 'primaryBorderColor': '#9D6EE0', 'lineColor': '#64748b', 'secondaryColor': '#004088', 'tertiaryColor': '#0f172a'}}}%%

graph TB
    direction TB

    Actor(["👤 SRE / Operador"])

    subgraph HOST ["  💻  MÁQUINA HOST — localhost  "]
        direction LR

        subgraph DEV ["  🟦  AMBIENTE DEVELOPMENT  "]
            direction TB
            WD["🐳 dev-frontend-app\n─────────────────\nNginx 1.27.0\nPuerto 8083"]
            DD["🐘 dev-postgres-db\n─────────────────\nPostgreSQL 15\nRed Interna"]
            WD -- "TCP Interno" --> DD
        end

        subgraph PROD ["  🟩  AMBIENTE PRODUCTION  "]
            direction TB
            WP["🐳 prod-frontend-app\n──────────────────\nNginx 1.27.0\nPuerto 8084"]
            DP["🐘 prod-postgres-db\n──────────────────\nPostgreSQL 16.2\nRed Interna"]
            WP -- "TCP Interno" --> DP
        end
    end

    Actor -- ":8083 HTTP" --> WD
    Actor -- ":8084 HTTP" --> WP

    DEV ~~~ PROD

    style HOST fill:#0f172a,stroke:#475569,stroke-width:2px,color:#e2e8f0
    style DEV fill:#1e3a5f,stroke:#3b82f6,stroke-width:2px,color:#93c5fd
    style PROD fill:#14532d,stroke:#22c55e,stroke-width:2px,color:#86efac
    style WD fill:#1e293b,stroke:#3b82f6,stroke-width:1px,color:#bfdbfe
    style DD fill:#1e293b,stroke:#3b82f6,stroke-width:1px,color:#bfdbfe
    style WP fill:#1e293b,stroke:#22c55e,stroke-width:1px,color:#bbf7d0
    style DP fill:#1e293b,stroke:#22c55e,stroke-width:1px,color:#bbf7d0
    style Actor fill:#7B42BC,stroke:#9D6EE0,color:#fff
```

> 🔒 **Principio de aislamiento**: las redes `dev-network` y `prod-network` son completamente independientes.  
> Ningún contenedor de un ambiente puede comunicarse con el del otro.

---

## 🏛️ Estructura del Repositorio

```plaintext
📁 lab-desacoplado/
│
├── 📁 modules/
│   └── 📁 stack-aplicacion/         ← 🧩 MÓDULO ÚNICO (Terraform puro)
│       ├── 📄 variables.tf           ← Definición de parámetros de entrada
│       └── 📄 main.tf                ← Lógica declarativa de infraestructura
│
└── 📁 environments/                  ← 🎛️ ORQUESTACIÓN POR AMBIENTE (Terragrunt)
    ├── 📁 dev-stack/                 ← Instancia Desarrollo (Puerto 8083 · PG 15)
    │   └── 📄 terragrunt.hcl
    └── 📁 prod-stack/               ← Instancia Producción (Puerto 8084 · PG 16.2)
        └── 📄 terragrunt.hcl
```

> **📐 Separación de responsabilidades**: el módulo define el *qué* (infraestructura),  
> Terragrunt define el *cómo* y *dónde* (valores por ambiente).

---

## 🚀 Flujo de Ejecución

```mermaid
%%{init: {'theme': 'dark', 'themeVariables': {'primaryColor': '#7B42BC', 'edgeLabelBackground': '#1e293b', 'lineColor': '#64748b'}}}%%

flowchart LR
    A(["📝 Fase 1\nMoldes .tf\nDefinición"])
    B(["⚙️ Fase 2\nInputs .hcl\nConfiguración"])
    C(["▶️ Fase 3\nterragrunt apply\nDespliegue"])
    D(["🔍 Fase 4\nAuditoría\nValidación"])
    E(["🗑️ Fase 5\nCierre\nControlado"])

    A --> B --> C --> D --> E

    style A fill:#7B42BC,stroke:#9D6EE0,color:#fff,rx:8
    style B fill:#004088,stroke:#3b82f6,color:#fff,rx:8
    style C fill:#15803d,stroke:#22C55E,color:#fff,rx:8
    style D fill:#b45309,stroke:#F59E0B,color:#fff,rx:8
    style E fill:#9b1c1c,stroke:#D9534F,color:#fff,rx:8
```

---

## 🛠️ Guía de Operación Paso a Paso

### ① Aprovisionamiento de Entornos

```bash
# ── DEVELOPMENT ──────────────────────────────────────────
cd environments/dev-stack/
terragrunt apply -auto-approve
# → Despliega: dev-frontend-app (Nginx 1.27.0:8083)
# → Despliega: dev-postgres-db  (PostgreSQL 15)
# → Crea red:  dev-network

# ── PRODUCTION ───────────────────────────────────────────
cd ../prod-stack/
terragrunt apply -auto-approve
# → Despliega: prod-frontend-app (Nginx 1.27.0:8084)
# → Despliega: prod-postgres-db  (PostgreSQL 16.2)
# → Crea red:  prod-network
```

### ② Verificación del Aislamiento

```bash
# Inspeccionar contenedores activos con sus imágenes y puertos
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}"

# Confirmar redes aisladas por ambiente
docker network ls | grep -E "dev|prod"
```

**Salida esperada:**

```
NAMES                  IMAGE                PORTS
prod-frontend-app      nginx:1.27.0         0.0.0.0:8084->80/tcp
prod-postgres-db       postgres:16.2        5432/tcp
dev-frontend-app       nginx:1.27.0         0.0.0.0:8083->80/tcp
dev-postgres-db        postgres:15          5432/tcp
```

### ③ Desmantelamiento Controlado

> ⚠️ **Orden obligatorio**: destruir `prod-stack` primero para evitar bloqueos del daemon Docker  
> por dependencias compartidas de imagen base.

```bash
# ── 1. Remover Producción (primero) ──────────────────────
cd environments/prod-stack/
terragrunt destroy -auto-approve

# ── 2. Remover Desarrollo (al final) ─────────────────────
cd ../dev-stack/
terragrunt destroy -auto-approve
```

---

## 🛡️ Controles de Seguridad SRE

```mermaid
%%{init: {'theme': 'dark'}}%%

mindmap
  root((🔒 Seguridad\nSRE))
    Inmutabilidad
      Sin etiqueta :latest
      Versiones fijas y auditables
      Builds reproducibles
    Motor Confiable
      terraform_binary = terraform
      Protección ante forks OpenTofu
      Fidelidad del ejecutor garantizada
    Parcheo Semántico
      Operador ~> 3.0.2
      Absorción de parches menores
      Sin breaking changes
    Grafo de Dependencias
      depends_on declarativo
      DB despliega antes que Web
      Eliminación de race conditions
```

| Control | Técnica | Beneficio |
|--------|---------|-----------|
| 🔒 **Inmutabilidad absoluta** | Versiones explícitas (`nginx:1.27.0`, `postgres:16.2`) | Elimina fallos por actualizaciones silenciosas |
| 🎯 **Motor controlado** | `terraform_binary = "terraform"` en raíz | Protección ante forks alternativos (OpenTofu) |
| 🔄 **Parcheo semántico** | Operador `~> 3.0.2` en providers | Absorbe parches de seguridad menores automáticamente |
| 📊 **Orden de despliegue** | Bloque `depends_on` explícito | Base de datos siempre disponible antes que el frontend |

---

## 📐 Principio DRY en Práctica

```mermaid
%%{init: {'theme': 'dark', 'themeVariables': {'primaryColor': '#7B42BC'}}}%%

graph LR
    MOD["🧩 modules/stack-aplicacion\n─────────────────────────\nmain.tf · variables.tf\n\nUN SOLO MÓDULO"]

    DEV_HCL["📄 environments/dev-stack\nterragrunt.hcl\n─────────────────\nnginx_version = 1.27.0\npostgres_version = 15\nhttp_port = 8083\nenv_name = development"]

    PROD_HCL["📄 environments/prod-stack\nterragrunt.hcl\n─────────────────\nnginx_version = 1.27.0\npostgres_version = 16.2\nhttp_port = 8084\nenv_name = production"]

    DEV_OUT["🟦 Stack Development\ndev-frontend-app\ndev-postgres-db\ndev-network"]
    PROD_OUT["🟩 Stack Production\nprod-frontend-app\nprod-postgres-db\nprod-network"]

    MOD --> DEV_HCL --> DEV_OUT
    MOD --> PROD_HCL --> PROD_OUT

    style MOD fill:#7B42BC,stroke:#9D6EE0,color:#fff
    style DEV_HCL fill:#004088,stroke:#3b82f6,color:#fff
    style PROD_HCL fill:#004088,stroke:#3b82f6,color:#fff
    style DEV_OUT fill:#1e3a5f,stroke:#3b82f6,color:#93c5fd
    style PROD_OUT fill:#14532d,stroke:#22c55e,color:#86efac
```

> Un módulo → múltiples ambientes. **Modificar una sola fuente de verdad impacta todos los entornos de forma controlada.**

---

## ✅ Checklist de Validación Post-Despliegue

```bash
# 1. Frontend Development accesible
curl -s -o /dev/null -w "%{http_code}" http://localhost:8083
# Esperado: 200

# 2. Frontend Production accesible
curl -s -o /dev/null -w "%{http_code}" http://localhost:8084
# Esperado: 200

# 3. Aislamiento de redes confirmado
docker network inspect dev-network  | grep -c "dev-"
docker network inspect prod-network | grep -c "prod-"

# 4. Conectividad interna DB → Web (solo dentro del mismo ambiente)
docker exec dev-frontend-app ping -c 1 dev-postgres-db
```

---

## 📦 Requisitos Previos

| Herramienta | Versión Mínima | Verificación |
|-------------|---------------|--------------|
| `terraform` | `>= 1.5.0` | `terraform version` |
| `terragrunt` | `>= 0.55.0` | `terragrunt --version` |
| `docker` | `>= 24.0` | `docker --version` |
| `docker compose` | Plugin v2 | `docker compose version` |

---

<div align="center">

**📚 Módulo 2 — Laboratorio Complementario de Orquestación Avanzada Multi-Tier**

*Construido bajo la disciplina **Site Reliability Engineering** — infraestructura como código, operada con rigor.*

[![Hecho con Terraform](https://img.shields.io/badge/Hecho_con-Terraform-7B42BC?style=flat-square&logo=terraform)](https://terraform.io)
[![Orquestado con Terragrunt](https://img.shields.io/badge/Orquestado_con-Terragrunt-004088?style=flat-square)](https://terragrunt.gruntwork.io)
[![Contenedores Docker](https://img.shields.io/badge/Contenedores-Docker-2496ED?style=flat-square&logo=docker)](https://docker.com)

</div>

