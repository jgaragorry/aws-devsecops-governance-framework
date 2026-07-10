# 🐇 RBK-IAC-RABBIT-03 · Orquestación Multi-Ambiente RabbitMQ

![Version](https://img.shields.io/badge/Versión-1.0-blue?style=for-the-badge&logo=semver)
![Estado](https://img.shields.io/badge/Estado-APROBADO-brightgreen?style=for-the-badge&logo=checkmarx)
![Nivel](https://img.shields.io/badge/Nivel-SRE%20Novato%20→%20Pro-orange?style=for-the-badge&logo=buffer)
![Stack](https://img.shields.io/badge/Stack-Terraform%20%7C%20Terragrunt%20%7C%20Docker-purple?style=for-the-badge&logo=terraform)
![Broker](https://img.shields.io/badge/Broker-RabbitMQ%203.13-FF6600?style=for-the-badge&logo=rabbitmq)

> **Propósito:** Guiar a cualquier operador, con o sin experiencia previa, en la construcción, despliegue, auditoría y destrucción segura de un clúster desacoplado de RabbitMQ en Alta Disponibilidad Local usando IaC profesional.

---

## 🗺️ Hoja de Ruta del Operador

```mermaid
flowchart LR
    F1(["📂 FASE 1\nAndamiaje"]):::fase1
    F2(["⚙️ FASE 2\nGobernanza"]):::fase2
    F3(["🧱 FASE 3\nMódulo Core"]):::fase3
    F4(["🌿 FASE 4\nHojas de Entorno"]):::fase4
    F5(["🚀 FASE 5\nDespliegue"]):::fase5
    F6(["🧹 FASE 6\nDestrucción"]):::fase6

    F1 --> F2 --> F3 --> F4 --> F5 --> F6

    classDef fase1 fill:#FFD700,color:#000,stroke:#b8a000,stroke-width:2px,rx:12
    classDef fase2 fill:#1E90FF,color:#fff,stroke:#0066cc,stroke-width:2px,rx:12
    classDef fase3 fill:#32CD32,color:#fff,stroke:#228B22,stroke-width:2px,rx:12
    classDef fase4 fill:#FF8C00,color:#fff,stroke:#cc6600,stroke-width:2px,rx:12
    classDef fase5 fill:#BA55D3,color:#fff,stroke:#8B008B,stroke-width:2px,rx:12
    classDef fase6 fill:#DC143C,color:#fff,stroke:#8B0000,stroke-width:2px,rx:12
```

---

## 📂 FASE 1 · Andamiaje de Directorios

![Tipo](https://img.shields.io/badge/Tipo-Infraestructura-FFD700?style=flat-square) ![Riesgo](https://img.shields.io/badge/Riesgo-Bajo-brightgreen?style=flat-square)

> **💡 ¿Por qué?** La segmentación estricta de carpetas es la primera línea de defensa SRE. Separar `modules` (código genérico) de `environments` (ejecuciones concretas) blinda producción contra manipulaciones accidentales.

### Arquitectura de Directorios

```mermaid
graph TD
    ROOT["📁 iac-mastery_3/"]:::root
    ENV["📁 environments/"]:::dir
    MOD["📁 modules/"]:::dir
    DEV["📁 dev/"]:::dev
    PROD["📁 prod/"]:::prod
    DEVAPP["📁 app-rabbitmq/"]:::leaf
    PRODAPP["📁 app-rabbitmq/"]:::leaf
    CLUSTER["📁 cluster-rabbitmq/"]:::leaf

    ROOT --> ENV
    ROOT --> MOD
    ENV --> DEV
    ENV --> PROD
    DEV --> DEVAPP
    PROD --> PRODAPP
    MOD --> CLUSTER

    classDef root fill:#1a1a2e,color:#fff,stroke:#444,stroke-width:2px
    classDef dir fill:#16213e,color:#fff,stroke:#444
    classDef dev fill:#1E90FF,color:#fff,stroke:#0066cc
    classDef prod fill:#FF8C00,color:#fff,stroke:#cc6600
    classDef leaf fill:#32CD32,color:#fff,stroke:#228B22
```

### Comandos de Provisión

```bash
mkdir -p ~/sre-linux-mastery/Fase2/iac-mastery_3/environments/dev/app-rabbitmq \
         ~/sre-linux-mastery/Fase2/iac-mastery_3/environments/prod/app-rabbitmq \
         ~/sre-linux-mastery/Fase2/iac-mastery_3/modules/cluster-rabbitmq

cd ~/sre-linux-mastery/Fase2/iac-mastery_3
```

### ✅ Validación de Sanidad

```bash
tree
```

**Resultado esperado:**

```
.
├── environments
│   ├── dev
│   │   └── app-rabbitmq
│   └── prod
│       └── app-rabbitmq
└── modules
    └── cluster-rabbitmq
```

---

## ⚙️ FASE 2 · Gobernanza Central

![Tipo](https://img.shields.io/badge/Tipo-Configuración%20Global-1E90FF?style=flat-square) ![Archivo](https://img.shields.io/badge/Archivo-terragrunt.hcl-blueviolet?style=flat-square)

> **💡 ¿Por qué?** Las reglas globales en la raíz unifican el comportamiento de las herramientas. Forzar el binario de Terraform y automatizar la generación del proveedor elimina discrepancias entre miembros del equipo.

```bash
nano terragrunt.hcl
```

```hcl
# ⚙️ Gobernanza: Forzar binario oficial de Terraform
# Blindaje contra ejecuciones cruzadas con OpenTofu en el PATH
terraform_binary = "terraform"

# Generación dinámica del proveedor de Docker en cada hoja de entorno
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "docker" {
  host = "unix:///var/run/docker.sock"
}
EOF
}
```

---

## 🧱 FASE 3 · Módulo Core Inmutable

![Tipo](https://img.shields.io/badge/Tipo-Terraform%20Puro-32CD32?style=flat-square) ![Patrón](https://img.shields.io/badge/Patrón-DRY%20Module-success?style=flat-square)

> **💡 ¿Por qué?** Siguiendo estándares de modularización industrial, dividimos responsabilidades en archivos independientes. El módulo se convierte en una plantilla pura reutilizable que abstrae la complejidad técnica.

### Arquitectura de Archivos del Módulo

```mermaid
graph LR
    subgraph "📁 modules/cluster-rabbitmq/"
        V["📄 variables.tf\n(Receptores)"]:::vars
        M["📄 main.tf\n(Lógica)"]:::main
        O["📄 outputs.tf\n(Emisores)"]:::out
    end

    V -->|"inyecta datos"| M
    M -->|"expone resultados"| O

    classDef vars fill:#1E90FF,color:#fff,stroke:#0066cc
    classDef main fill:#32CD32,color:#fff,stroke:#228B22
    classDef out fill:#FF8C00,color:#fff,stroke:#cc6600
```

---

### 3.1 · `variables.tf` — Los Receptores del Sistema

```bash
nano modules/cluster-rabbitmq/variables.tf
```

```hcl
variable "nombre_mq" {
  type        = string
  description = "Nombre único de identificación para el contenedor RabbitMQ."
}

variable "puerto_amqp" {
  type        = number
  description = "Puerto externo para el protocolo de mensajería AMQP del broker."
}

variable "puerto_management" {
  type        = number
  description = "Puerto externo para la interfaz web de administración visual."
}

variable "rabbitmq_user" {
  type        = string
  description = "Usuario administrador por defecto (Hardening de Seguridad)."
}

variable "rabbitmq_pass" {
  type        = string
  description = "Contraseña administrativa por defecto (Hardening de Seguridad)."
  sensitive   = true   # 🔒 Oculta el valor en logs y outputs de plan
}

variable "entorno" {
  type        = string
  description = "Etiqueta identificadora del ciclo de vida del entorno."
}
```

---

### 3.2 · `main.tf` — La Lógica de Aprovisionamiento

```bash
nano modules/cluster-rabbitmq/main.tf
```

```hcl
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# 🐳 Descarga la imagen oficial con el plugin de Management preactivado
resource "docker_image" "rabbitmq" {
  name         = "rabbitmq:3.13-management-alpine"
  keep_locally = true  # 🛡️ Evita borrar la imagen local al hacer destroy
}

# 🐇 Instancia el Message Broker con credenciales inyectadas
resource "docker_container" "mq_broker" {
  image = docker_image.rabbitmq.image_id
  name  = var.nombre_mq

  # 🔒 Hardening: Credenciales via variables de entorno del contenedor
  env = [
    "RABBITMQ_DEFAULT_USER=${var.rabbitmq_user}",
    "RABBITMQ_DEFAULT_PASS=${var.rabbitmq_pass}"
  ]

  # 🔌 Mapeo de puertos: AMQP (mensajes) + Management (dashboard web)
  ports {
    internal = 5672
    external = var.puerto_amqp
  }

  ports {
    internal = 15672
    external = var.puerto_management
  }

  # 🏷️ Etiquetas para observabilidad, auditoría y gestión de costos
  labels {
    label = "environment"
    value = var.entorno
  }
  labels {
    label = "orchestrator"
    value = "terragrunt"
  }
}
```

---

### 3.3 · `outputs.tf` — Los Emisores del Sistema

```bash
nano modules/cluster-rabbitmq/outputs.tf
```

```hcl
output "mq_container_id" {
  value       = docker_container.mq_broker.id
  description = "Identificador único del contenedor para auditoría SRE."
}

output "amqp_uri" {
  value       = "amqp://${var.rabbitmq_user}:****@127.0.0.1:${var.puerto_amqp}"
  description = "Cadena de conexión segura para microservicios Productores/Consumidores."
}

output "management_url" {
  value       = "http://localhost:${var.puerto_management}"
  description = "URL de acceso a la consola de administración visual."
}
```

---

## 🌿 FASE 4 · Configuración de Hojas de Entorno

![Tipo](https://img.shields.io/badge/Tipo-Inyección%20de%20Valores-FF8C00?style=flat-square) ![Patrón](https://img.shields.io/badge/Patrón-Environment%20Leaf-orange?style=flat-square)

> **💡 ¿Por qué?** Aquí la plantilla inmutable cobra vida. Inyectamos los valores reales que diferencian cada entorno: puertos aislados para evitar colisiones de red, credenciales propias y etiquetas específicas.

### Flujo de Herencia de Configuración

```mermaid
flowchart TD
    ROOT["⚙️ /terragrunt.hcl\nGobernanza Global"]:::root
    ENVHCL_D["📄 dev/env.hcl\nlocals env=dev"]:::dev
    ENVHCL_P["📄 prod/env.hcl\nlocals env=prod"]:::prod
    LEAF_D["🌿 dev/app-rabbitmq/terragrunt.hcl\nPuertos 5672 / 15672"]:::dev
    LEAF_P["🌿 prod/app-rabbitmq/terragrunt.hcl\nPuertos 5673 / 15673"]:::prod
    MODULE["🧱 modules/cluster-rabbitmq\nTerraform Puro"]:::module

    ROOT --> LEAF_D
    ROOT --> LEAF_P
    ENVHCL_D --> LEAF_D
    ENVHCL_P --> LEAF_P
    LEAF_D --> MODULE
    LEAF_P --> MODULE

    classDef root fill:#1a1a2e,color:#fff,stroke:#444
    classDef dev fill:#1E90FF,color:#fff,stroke:#0066cc
    classDef prod fill:#FF8C00,color:#fff,stroke:#cc6600
    classDef module fill:#32CD32,color:#fff,stroke:#228B22
```

---

### 4.1 · Identificadores Locales

**Entorno DEV:**
```bash
nano environments/dev/env.hcl
```
```hcl
locals { env = "dev" }
```

**Entorno PROD:**
```bash
nano environments/prod/env.hcl
```
```hcl
locals { env = "prod" }
```

---

### 4.2 · Hoja DEV — Perfil Estándar

```bash
nano environments/dev/app-rabbitmq/terragrunt.hcl
```

```hcl
include "root" {
  path = "../../../terragrunt.hcl"
}

locals {
  env_vars = read_terragrunt_config("../env.hcl")
  entorno  = local.env_vars.locals.env
}

terraform {
  source = "../../../modules//cluster-rabbitmq"  # ⚡ // separa repo de subdirectorio
}

inputs = {
  nombre_mq         = "sre-mq-dev"
  puerto_amqp       = 5672            # Puerto AMQP estándar
  puerto_management = 15672           # Dashboard estándar de RabbitMQ
  rabbitmq_user     = "dev_admin"
  rabbitmq_pass     = "dev_secret_pass_2026"
  entorno           = local.entorno
}
```

---

### 4.3 · Hoja PROD — Perfil de Alta Seguridad

```bash
nano environments/prod/app-rabbitmq/terragrunt.hcl
```

```hcl
include "root" {
  path = "../../../terragrunt.hcl"
}

locals {
  env_vars = read_terragrunt_config("../env.hcl")
  entorno  = local.env_vars.locals.env
}

terraform {
  source = "../../../modules//cluster-rabbitmq"  # ⚡ // separa repo de subdirectorio
}

inputs = {
  nombre_mq         = "sre-mq-prod"
  puerto_amqp       = 5673            # Puerto aislado — evita colisión con DEV
  puerto_management = 15673           # Dashboard aislado — evita colisión con DEV
  rabbitmq_user     = "prod_cluster_boss"
  rabbitmq_pass     = "prod_ultra_secure_password_2026"
  entorno           = local.entorno
}
```

> **⚡ Nota Técnica:** El doble slash `//` en `source` le indica explícitamente a Terraform dónde termina el repositorio local y dónde inicia el subdirectorio del módulo ejecutable.

---

## 🚀 FASE 5 · Despliegue Operacional y Smoke Tests

![Tipo](https://img.shields.io/badge/Tipo-Despliegue%20Activo-BA55D3?style=flat-square) ![Tests](https://img.shields.io/badge/Tests-Smoke%20Tests-blueviolet?style=flat-square)

> **💡 ¿Por qué?** Compilamos el código abstracto de IaC para transformarlo en infraestructura viva. Luego ejecutamos smoke tests para certificar que el motor interno de mensajería Erlang arrancó correctamente.

### 5.1 · Lanzar Entorno DEV

```bash
cd ~/sre-linux-mastery/Fase2/iac-mastery_3/environments/dev/app-rabbitmq/
rm -rf .terragrunt-cache/
terragrunt apply -auto-approve
```

### 5.2 · Lanzar Entorno PROD

```bash
cd ~/sre-linux-mastery/Fase2/iac-mastery_3/environments/prod/app-rabbitmq/
rm -rf .terragrunt-cache/
terragrunt apply -auto-approve
```

---

### 5.3 · Auditoría de Salud — Smoke Tests

**Paso 1: Verificar coexistencia de contenedores**

```bash
docker ps
```

**Salida de éxito esperada:**

```
CONTAINER ID   IMAGE            COMMAND                  PORTS                                              NAMES
e3835cd6c3ba   606d8c0d6b3c    "docker-entrypoint.s…"   0.0.0.0:5673->5672/tcp, 0.0.0.0:15673->15672/tcp  sre-mq-prod
bc7149e05f77   606d8c0d6b3c    "docker-entrypoint.s…"   0.0.0.0:5672->5672/tcp, 0.0.0.0:15672->15672/tcp  sre-mq-dev
```

**Paso 2: Diagnóstico interno RabbitMQ**

```bash
docker exec -it sre-mq-dev  rabbitmq-diagnostics check_running
docker exec -it sre-mq-prod rabbitmq-diagnostics check_running
```

### Flujo de Diagnóstico Esperado

```mermaid
sequenceDiagram
    actor SRE as 👤 Ingeniero SRE
    participant DEV  as 🟦 Broker DEV<br/>(:5672 / :15672)
    participant PROD as 🟠 Broker PROD<br/>(:5673 / :15673)

    Note over SRE,PROD: 🔍 Smoke Tests — Verificación de arranque Erlang

    SRE->>DEV: rabbitmq-diagnostics check_running
    activate DEV
    DEV-->>SRE: ✅ RabbitMQ is fully booted and running
    deactivate DEV

    SRE->>PROD: rabbitmq-diagnostics check_running
    activate PROD
    PROD-->>SRE: ✅ RabbitMQ is fully booted and running
    deactivate PROD

    Note over SRE,PROD: 🟢 Ambos brokers operativos y aislados
```

---

## 🧹 FASE 6 · Destrucción Controlada y Aislada

![Tipo](https://img.shields.io/badge/Tipo-Operación%20Destructiva-DC143C?style=flat-square) ![Blast Radius](https://img.shields.io/badge/Blast%20Radius-Controlado-success?style=flat-square)

> **💡 ¿Por qué?** Validamos empíricamente que desmantelar un entorno efímero NO interrumpe la disponibilidad de los servicios productivos. Esta es la prueba definitiva del aislamiento de tu IaC.

### 6.1 · Destruir Entorno DEV (Aislado)

```bash
cd ~/sre-linux-mastery/Fase2/iac-mastery_3/environments/dev/app-rabbitmq/
terragrunt destroy -auto-approve
```

**Validación inmediata post-destroy:**

```bash
docker ps
```

**Resultado esperado:**

```
CONTAINER ID   IMAGE            COMMAND                  PORTS                                              NAMES
e3835cd6c3ba   606d8c0d6b3c    "docker-entrypoint.s…"   0.0.0.0:5673->5672/tcp, 0.0.0.0:15673->15672/tcp  sre-mq-prod
```

> **🛡️ Validado:** `sre-mq-dev` eliminado limpiamente. `sre-mq-prod` intacto y operativo gracias a `keep_locally = true`. El **Blast Radius está perfectamente contenido**.

### 6.2 · Cierre Técnico Completo (Destrucción de PROD)

```bash
cd ~/sre-linux-mastery/Fase2/iac-mastery_3/environments/prod/app-rabbitmq/
terragrunt destroy -auto-approve
```

### Diagrama de Blast Radius Controlado

```mermaid
flowchart LR
    subgraph DESTROY["💣 Destroy DEV"]
        D_DEV["🗑️ sre-mq-dev\nEliminado"]:::destroyed
    end

    subgraph SAFE["🛡️ Entorno Productivo"]
        D_PROD["✅ sre-mq-prod\nIntacto y Operativo"]:::safe
    end

    DESTROY -.->|"sin impacto"| SAFE

    classDef destroyed fill:#DC143C,color:#fff,stroke:#8B0000
    classDef safe fill:#32CD32,color:#fff,stroke:#228B22
```

---

## 📋 Matriz de Referencia Operativa

| Parámetro Operacional | 🟦 Entorno DEV | 🟠 Entorno PROD |
|---|---|---|
| **Nombre del Contenedor** | `sre-mq-dev` | `sre-mq-prod` |
| **Puerto AMQP** | `5672` | `5673` |
| **Puerto Management** | `15672` | `15673` |
| **Usuario Admin** | `dev_admin` | `prod_cluster_boss` |
| **URI AMQP** | `amqp://dev_admin:****@127.0.0.1:5672` | `amqp://prod_cluster_boss:****@127.0.0.1:5673` |
| **Dashboard Web** | `http://localhost:15672` | `http://localhost:15673` |
| **Keep Image Locally** | `true` ✅ | `true` ✅ |

---

## 🧩 Mapa de Dependencias de Archivos

```mermaid
graph TD
    TG_ROOT["⚙️ terragrunt.hcl\nRaíz del Proyecto"]:::root

    subgraph "🌿 environments/dev/app-rabbitmq/"
        TG_DEV["terragrunt.hcl"]:::dev
    end

    subgraph "🌿 environments/prod/app-rabbitmq/"
        TG_PROD["terragrunt.hcl"]:::prod
    end

    subgraph "🧱 modules/cluster-rabbitmq/"
        VARS["variables.tf"]:::module
        MAIN["main.tf"]:::module
        OUTS["outputs.tf"]:::module
    end

    ENV_DEV["📄 dev/env.hcl"]:::dev
    ENV_PROD["📄 prod/env.hcl"]:::prod

    TG_ROOT -->|"include root"| TG_DEV
    TG_ROOT -->|"include root"| TG_PROD
    ENV_DEV -->|"read_terragrunt_config"| TG_DEV
    ENV_PROD -->|"read_terragrunt_config"| TG_PROD
    TG_DEV -->|"source module"| VARS & MAIN & OUTS
    TG_PROD -->|"source module"| VARS & MAIN & OUTS

    classDef root fill:#1a1a2e,color:#eee,stroke:#555
    classDef dev fill:#1E90FF,color:#fff,stroke:#0066cc
    classDef prod fill:#FF8C00,color:#fff,stroke:#cc6600
    classDef module fill:#32CD32,color:#fff,stroke:#228B22
```

---

## 🔑 Glosario Técnico

| Término | Definición |
|---|---|
| **AMQP** | Advanced Message Queuing Protocol — protocolo estándar de mensajería entre microservicios |
| **Blast Radius** | Radio de impacto de una operación destructiva; debe ser mínimo y controlado |
| **DRY** | Don't Repeat Yourself — principio que justifica la modularización |
| **Erlang** | Plataforma de runtime donde corre el motor interno de RabbitMQ |
| **IaC** | Infrastructure as Code — gestión de infraestructura mediante código versionable |
| **keep_locally** | Flag de Terraform que preserva la imagen Docker local al ejecutar `destroy` |
| **Smoke Test** | Prueba rápida de arranque que verifica el estado funcional mínimo de un servicio |
| **Terragrunt** | Wrapper de Terraform que habilita DRY, herencia de configuración y orquestación multi-entorno |

---

> **📄 Doc:** `RBK-IAC-RABBIT-03` · **v1.0** · Estado: `APROBADO` · Nivel: `SRE Novato → Pro`

