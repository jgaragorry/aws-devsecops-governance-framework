# 🧱 `iac-mastery_2` · Orquestación de Base de Datos Inmutable (DRY)

<div align="center">

![Terragrunt](https://img.shields.io/badge/Terragrunt-v0.60+-1A73E8?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0id2hpdGUiIGQ9Ik0xMiAyTDIgN2wxMCA1IDEwLTV6TTIgMTdsOSA1IDktNXYtOGwtOSA1LTktNXoiLz48L3N2Zz4=&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-v1.5+-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-v7.2_Alpine-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Runtime-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Pattern](https://img.shields.io/badge/Pattern-Modular_Senior-22C55E?style=for-the-badge)
![SRE](https://img.shields.io/badge/SRE-Hardening-FF6B35?style=for-the-badge)

<br/>

> **Laboratorio Avanzado de Persistencia y Caché** que implementa un clúster desacoplado de Redis  
> en Alta Disponibilidad Local bajo principios estrictos de **Site Reliability Engineering (SRE)**.

<br/>

[![Objetivos](https://img.shields.io/badge/→-Objetivos-1A73E8?style=flat-square)](#-objetivos-del-laboratorio)
[![Arquitectura](https://img.shields.io/badge/→-Arquitectura-7B42BC?style=flat-square)](#️-arquitectura-de-bloques)
[![Anatomía](https://img.shields.io/badge/→-Anatomía-22C55E?style=flat-square)](#-anatomía-del-repositorio)
[![Hardening](https://img.shields.io/badge/→-Hardening_SRE-DC382D?style=flat-square)](#️-hardening-sre--buenas-prácticas)
[![Runbook](https://img.shields.io/badge/→-Runbook-FF6B35?style=flat-square)](#-ejecución-operacional)

</div>

---

## 🎯 Objetivos del Laboratorio

Este repositorio resuelve el desafío de desplegar **Bases de Datos de alto rendimiento** en entornos compartidos. Demuestra cómo parametrizar políticas de memoria y aislamiento de red en `Desarrollo` y `Producción` reutilizando un único módulo *Core* inmutable, garantizando **reproducibilidad en el primer intento**.

<br/>

<table>
<tr>
<td width="50%">

### ❌ Enfoque Tradicional (Frágil)

- 🔴 Imágenes borradas por conflicto de daemon
- 🔴 Puertos colisionados (todos en `:6379`)
- 🔴 Consumo descontrolado de RAM
- 🔴 Módulos duplicados por entorno
- 🔴 Sin separación dev / prod

</td>
<td width="50%">

### ✅ Arquitectura `iac-mastery_2`

- 🟢 Mitigación con `keep_locally = true`
- 🟢 Aislamiento de Red (`:6379` vs `:6380`)
- 🟢 Hardening SRE con `--maxmemory`
- 🟢 Módulo Core **único e inmutable**
- 🟢 DRY estricto vía Terragrunt

</td>
</tr>
</table>

---

## 🗺️ Arquitectura de Bloques

El siguiente diagrama modela el flujo de **inyección de dependencias**. La gobernanza raíz automatiza el proveedor, las hojas de entorno configuran el contexto, y el módulo genera los recursos vivos en el motor de Docker.

```mermaid
flowchart TD
    subgraph Capa_Gobernanza ["⚙️ GOBERNANZA CENTRAL"]
        Root["📄 terragrunt.hcl · Raíz\n─────────────────────\n• Forzado de Binario Oficial\n• Generación automática de provider.tf"]
    end

    subgraph Capa_Contextos ["🌿 CONFIGURACIÓN DE ENTORNOS"]
        direction LR
        Dev["🟡 AMBIENTE DEV\n──────────────\n• Puerto Host : 6379\n• RAM Límite  : 128mb\n• env.hcl (dev)"]
        Prod["🟠 AMBIENTE PROD\n───────────────\n• Puerto Host : 6380\n• RAM Límite  : 512mb\n• env.hcl (prod)"]
    end

    subgraph Capa_Modular ["🧱 MÓDULO CORE INMUTABLE"]
        Module["📦 modules/cluster-redis/\n─────────────────────────\n• main.tf      → Lógica de Recursos\n• variables.tf → Tipado Estricto\n• outputs.tf   → URIs de Conexión"]
    end

    subgraph Capa_Runtime ["🐳 RUNTIME LIVE · WSL Daemon"]
        direction LR
        ContDev["🐳 sre-redis-dev\n────────────────\nStatus : PONG ✅\nPolicy : allkeys-lru\nPort   : 6379"]
        ContProd["🐳 sre-redis-prod\n─────────────────\nStatus : PONG ✅\nPolicy : allkeys-lru\nPort   : 6380"]
    end

    Root ==>|"① Inyecta Proveedor"| Dev
    Root ==>|"① Inyecta Proveedor"| Prod
    Dev  -->|"② Envía Parámetros"| Module
    Prod -->|"② Envía Parámetros"| Module
    Module -->|"③ Crea Proceso Aislado"| ContDev
    Module -->|"③ Crea Proceso Aislado"| ContProd

    style Root      fill:#1E90FF,stroke:#0A5C9E,stroke-width:2px,color:#fff
    style Dev       fill:#FFF4CE,stroke:#DEB22C,stroke-width:2px,color:#000
    style Prod      fill:#FFE6D5,stroke:#E67E22,stroke-width:2px,color:#000
    style Module    fill:#E8F8F5,stroke:#2ECC71,stroke-width:2px,color:#000
    style ContDev   fill:#F2F4F4,stroke:#34495E,stroke-width:2px,color:#000
    style ContProd  fill:#F2F4F4,stroke:#2C3E50,stroke-width:2px,color:#000
```

---

## 📂 Anatomía del Repositorio

La segmentación sigue el **estándar senior de modularización**, separando lógica inmutable (módulos) de datos mutables (entornos).

```
iac-mastery_2/
│
├── 📄 terragrunt.hcl                    ← 🧠 Cerebro Central: Gobierna binarios y proveedores
│
├── 📁 modules/                          ← 🔒 CAPA INMUTABLE — Nunca se edita por entorno
│   └── 📁 cluster-redis/
│       ├── 📄 main.tf                   ←    Recursos Docker + argumentos de Redis
│       ├── 📄 variables.tf              ←    Tipado estricto de todas las variables
│       └── 📄 outputs.tf                ←    URIs y cadenas de conexión exportadas
│
└── 📁 environments/                     ← 🌿 CAPA VARIABLE — Datos y contextos únicos
    │
    ├── 📁 dev/
    │   ├── 📄 env.hcl                   ←    Identificador local: "dev"
    │   └── 📁 app-redis/
    │       └── 📄 terragrunt.hcl        ←    Puerto 6379 · RAM 128mb · baja prioridad
    │
    └── 📁 prod/
        ├── 📄 env.hcl                   ←    Identificador local: "prod"
        └── 📁 app-redis/
            └── 📄 terragrunt.hcl        ←    Puerto 6380 · RAM 512mb · alta prioridad
```

> 💡 **Principio DRY aplicado:** el módulo `cluster-redis/` existe **una sola vez**. Ambos entornos lo invocan con parámetros distintos. Modificar la lógica en un único lugar propaga el cambio a todos los contextos automáticamente.

---

## ⚡ Hardening SRE & Buenas Prácticas

### 🔵 `1` · Capacity Management — Gestión de Capacidad

Se inyectan argumentos estrictos (`--maxmemory`) directamente al motor de Redis. Cuando la base de datos alcanza el límite configurado, el algoritmo **evicción `allkeys-lru`** descarta las llaves menos utilizadas recientemente, emulando el comportamiento real de un caché de producción bajo presión de memoria.

```hcl
# Ejemplo: argumento inyectado en main.tf del módulo
command = ["--maxmemory", var.redis_max_memory, "--maxmemory-policy", "allkeys-lru"]
```

---

### 🟣 `2` · Mitigación de Race Conditions Locales

Al activar `keep_locally = true` en el recurso de imagen Docker, **blindamos el flujo** contra colisiones del daemon compartido en WSL. Un entorno puede destruirse por completo sin corromper los archivos del entorno paralelo.

```hcl
# Recurso en main.tf — imagen protegida contra borrado accidental
resource "docker_image" "redis" {
  name         = "redis:7.2-alpine"
  keep_locally = true   # ← Protección ante terraform destroy del entorno paralelo
}
```

---

### 🟢 `3` · Higiene de Formato Inmutable

Estricta separación de responsabilidades en archivos `.tf` independientes, 100% compatibles con las herramientas de formateo automatizado:

```bash
terraform fmt -recursive   # ← Formatea sin romper ningún archivo del módulo
```

---

## 📊 Matriz de Control Operativo

| Entorno | Contenedor | Puerto Host | RAM Límite | Política Evicc. | Comando de Salud | Estado |
|:-------:|:----------:|:-----------:|:----------:|:---------------:|:----------------:|:------:|
| 🟡 **DEV** | `sre-redis-dev` | `6379` | `128mb` | `allkeys-lru` | `redis-cli ping` | ✅ `PONG` |
| 🟠 **PROD** | `sre-redis-prod` | `6380` | `512mb` | `allkeys-lru` | `redis-cli ping` | ✅ `PONG` |

---

## 📖 Ejecución Operacional

Para recrear la estructura desde cero, inicializar cachés centralizados, ejecutar pruebas de humo cruzadas o realizar un desmantelamiento controlado **Zero Downtime**, consulta el manual quirúrgico completo:

<div align="center">

### ➡️ [`RUNBOOK_OPERACIONAL.md`](./RUNBOOK_OPERACIONAL.md)

*Guía paso a paso con comandos exactos para cada escenario operativo*

</div>

---

<div align="center">

**`iac-mastery_2`** · Especialización en Site Reliability Engineering

![SRE](https://img.shields.io/badge/SRE-Infraestructura_como_Código-1A73E8?style=flat-square)
![Principios](https://img.shields.io/badge/Principios-Gobernanza_·_Resiliencia_·_Reproducibilidad-22C55E?style=flat-square)

*Modularidad que escala · Código que se explica solo · Infraestructura que no falla*

</div>

