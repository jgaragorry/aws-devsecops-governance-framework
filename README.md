# 🚀 SRE Linux Specialization Mastery

<div align="center">

![SRE Specialization](https://img.shields.io/badge/Program-SRE%20Linux%20v2.0-2c3e50?style=for-the-badge&logo=linux&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active%20Development-27ae60?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0.0-3498db?style=for-the-badge)
[![License](https://img.shields.io/badge/License-Proprietary-e74c3c?style=for-the-badge)](./LICENSE)
[![Last Update](https://img.shields.io/badge/Last%20Updated-2026-95a5a6?style=for-the-badge)](#)

![GitHub Issues](https://img.shields.io/badge/Issues-Open-f39c12?style=flat-square)
![GitHub Stars](https://img.shields.io/badge/Stars-★★★★★-ffd700?style=flat-square)
![Contributor](https://img.shields.io/badge/Contributor-SOFTRAINCORP-1abc9c?style=flat-square)

---

> **Transforma tu carrera**: De ingeniero de sistemas tradicional a **Cloud Architect / SRE Enterprise-Ready**

Este repositorio es el **epicentro de la especialización SRE Linux v2.0**, consolidando toda la experiencia necesaria para dominar la ingeniería de confiabilidad de sistemas, automatización empresarial y observabilidad en infraestructuras modernas.

</div>

---

## 📋 Tabla de Contenidos

- [🎯 Objetivo](#-objetivo-del-repositorio)
- [✨ Características Principales](#-características-principales)
- [📦 Estructura del Repositorio](#-estructura-del-repositorio)
- [🗺️ Fases de Aprendizaje](#-fases-de-aprendizaje)
- [🚀 Quick Start](#-quick-start)
- [📊 Requisitos Previos](#-requisitos-previos)
- [🛠️ Stack Tecnológico](#-stack-tecnológico)
- [📚 Documentación Completa](#-documentación-completa)
- [🤝 Contribuciones](#-contribuciones)
- [📞 Soporte](#-soporte)
- [⚖️ Licencia y Acceso](#-licencia-y-acceso)

---

## 🎯 Objetivo del Repositorio

Este repositorio actúa como la **Single Source of Truth (SSOT)** centralizada para:

| Objetivo | Descripción |
|----------|-------------|
| 🏗️ **Infraestructura como Código** | Despliegues reproducibles, versionados y auditables con Terraform, Terragrunt y CloudFormation |
| 🤖 **Automatización a Escala** | Configuration Management idempotente con Ansible para miles de nodos |
| 🔍 **Observabilidad Empresarial** | Implementación de stacks de monitoreo, logging y distributed tracing |
| 🐧 **Linux Hardening Avanzado** | Auditoría forense, tunning de kernel y seguridad bajo estándares Enterprise |
| 🎯 **Runbooks Operacionales** | Procedimientos documentados para incidentes, escalamiento y troubleshooting |
| 📈 **Arquitecturas Multi-Cloud** | Patrones de deployments en AWS, Azure y GCP con alta disponibilidad |

---

## ✨ Características Principales

```
┌─────────────────────────────────────────────────────────────────┐
│                   ESPECIALIZACIÓN SRE v2.0                      │
├─────────────────────────────────────────────────────────────────┤
│ ✅ Scripts idempotentes y production-ready                      │
│ ✅ IaC con versionado y validación automática                   │
│ ✅ Playbooks Ansible optimizados para escala                    │
│ ✅ Runbooks con procedimientos paso a paso                      │
│ ✅ Laboratorios prácticos con entornos reales                   │
│ ✅ Configuraciones de seguridad bajo CIS Benchmarks            │
│ ✅ Documentación técnica de nivel Enterprise                    │
│ ✅ Mejores prácticas de observabilidad y SRE                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 Estructura del Repositorio

```
sre-linux-specialization/
│
├── 📄 README.md                          # Este archivo
├── 📄 LICENSE                            # Acceso exclusivo SOFTRAINCORP
├── 📄 CONTRIBUTING.md                    # Guía de contribución
│
├── 📁 phase0-onboarding/                 # [INICIO] Preparación del Entorno
│   ├── README.md
│   ├── sre_phase0_bootstrap.sh           # Script de instalación idempotente
│   ├── environment_check.md              # Checklist de requisitos
│   └── tools_installation.sh             # Setup de herramientas modernas
│
├── 📁 phase1-linux-core/                 # [CORE] Linux Deep Dive
│   ├── README.md
│   ├── hardening/
│   ├── kernel-tuning/
│   ├── forensics/
│   └── runbooks/
│
├── 📁 phase2-iac/                        # [IaC] Infraestructura como Código
│   ├── README.md
│   ├── terraform/
│   ├── terragrunt/
│   ├── cloudformation/
│   └── validation/
│
├── 📁 phase3-automation/                 # [AUTOMATION] Configuration Management
│   ├── README.md
│   ├── ansible/
│   ├── roles/
│   ├── playbooks/
│   └── tests/
│
├── 📁 phase4-containers/                 # [CONTAINERS] Containerización
│   ├── README.md
│   ├── docker/
│   ├── kubernetes/
│   ├── registry/
│   └── orchestration/
│
└── 📁 phase5-project/                    # [CAPSTONE] Proyecto Final
    ├── README.md
    ├── architecture/
    ├── deployment/
    ├── monitoring/
    └── validation/
```

---

## 🗺️ Fases de Aprendizaje

Las fases están diseñadas como una **secuencia progresiva y correlativa**. Cada fase consolida conceptos previos e introduce nuevas competencias.

### **Fase 0: Onboarding & Setup** 🔧
**Duración Estimada:** 1-2 semanas

Preparación integral del entorno de trabajo para garantizar que todos los estudiantes comienzan con los mismos requisitos técnicos.

```bash
Habilidades:
  ✓ Instalación de Ubuntu 24.04 LTS
  ✓ Setup de herramientas modernas (Rust, Go, Node.js)
  ✓ Configuración de Git y GitHub
  ✓ Ambiente de desarrollo de primer nivel
```

📖 **[Ir a Phase 0 →](./phase0-onboarding/README.md)**

---

### **Fase 1: Linux Deep Dive** 🐧
**Duración Estimada:** 3-4 semanas

Dominio profundo del kernel Linux, hardening enterprise y auditoría forense de sistemas.

```bash
Habilidades:
  ✓ Linux Kernel tuning y optimización
  ✓ Seguridad: CIS Benchmarks, AppArmor, SELinux
  ✓ Performance analysis y flame graphs
  ✓ Forensics: análisis de logs y recuperación de datos
  ✓ System hardening para producción
```

📖 **[Ir a Phase 1 →](./phase1-linux-core/README.md)**

---

### **Fase 2: IaC Mastery** 🏗️
**Duración Estimada:** 3-4 semanas

Infraestructura como código con Terraform, Terragrunt y validación automática para AWS, Azure y GCP.

```bash
Habilidades:
  ✓ Terraform: módulos, estados, variables
  ✓ Terragrunt: DRY, entornos múltiples
  ✓ CloudFormation en AWS
  ✓ Validación, testing y CI/CD para IaC
  ✓ Multi-cloud deployment patterns
```

📖 **[Ir a Phase 2 →](./phase2-iac/README.md)**

---

### **Fase 3: Configuration Management** 🤖
**Duración Estimada:** 3-4 semanas

Automatización idempotente a escala empresarial con Ansible, diseñada para gestionar miles de nodos.

```bash
Habilidades:
  ✓ Playbooks y roles Ansible avanzados
  ✓ Idempotencia y atomicidad
  ✓ Gestión de configuraciones multi-entorno
  ✓ Testing y validación de playbooks
  ✓ Orchestración de cambios en producción
```

📖 **[Ir a Phase 3 →](./phase3-automation/README.md)**

---

### **Fase 4: Containerization** 🐳
**Duración Estimada:** 3-4 semanas

Microservicios, resiliencia y orquestación con Docker y Kubernetes.

```bash
Habilidades:
  ✓ Docker: imágenes optimizadas, multi-stage builds
  ✓ Docker Compose para entornos locales
  ✓ Kubernetes: deployment, scaling, networking
  ✓ Helm charts y package management
  ✓ Observabilidad en contenedores
```

📖 **[Ir a Phase 4 →](./phase4-containers/README.md)**

---

### **Fase 5: Final Project** 🎯
**Duración Estimada:** 4-6 semanas

Proyecto integrador: arquitectura Multi-Cloud de alta disponibilidad, automatización completa y observabilidad empresarial.

```bash
Capstone:
  ✓ Diseño de arquitectura resiliente
  ✓ Despliegue multi-cloud automatizado
  ✓ Implementación de SLOs y SLIs
  ✓ Disaster recovery y failover
  ✓ Presentación y auditoría final
```

📖 **[Ir a Phase 5 →](./phase5-project/README.md)**

---

## 🚀 Quick Start

### **Opción 1: Bootstrap Automático**

```bash
# Clona el repositorio
git clone https://github.com/softraincorp/sre-linux-specialization.git
cd sre-linux-specialization

# Ejecuta el script de fase 0 (requiere Ubuntu 24.04)
cd phase0-onboarding
bash sre_phase0_bootstrap.sh

# Verifica tu entorno
bash environment_check.sh
```

### **Opción 2: Setup Manual**

```bash
# Pre-requisitos
- Ubuntu 24.04 LTS o superior
- Git 2.40+
- 10GB de espacio en disco
- Conexión a internet estable

# Sigue la guía paso a paso
cat phase0-onboarding/README.md
```

---

## 📊 Requisitos Previos

| Requisito | Versión Mínima | Verificar |
|-----------|-----------------|-----------|
| **OS** | Ubuntu 24.04 LTS | `lsb_release -a` |
| **Git** | 2.40+ | `git --version` |
| **Bash** | 5.1+ | `bash --version` |
| **RAM** | 8GB | `free -h` |
| **Espacio Disco** | 20GB | `df -h` |
| **CPU** | 4 cores | `nproc` |

**Herramientas que se instalarán automáticamente:**
- Rust (latest stable)
- Go 1.21+
- Node.js 20+
- Docker & Docker Compose
- Terraform & Terragrunt
- Ansible
- kubectl & Helm
- jq, yq, aws-cli, azure-cli

---

## 🛠️ Stack Tecnológico

<div align="center">

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Terraform](https://img.shields.io/badge/Terraform-844FBA?style=for-the-badge&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![GCP](https://img.shields.io/badge/GCP-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)

</div>

**Infraestructura & IaC:**
- Terraform & Terragrunt (provisioning)
- CloudFormation (AWS nativo)
- Pulumi (IaC alternatives)

**Automatización & Configuration:**
- Ansible (configuration management)
- Bash & Python (scripting)
- systemd (service management)

**Containerización & Orquestación:**
- Docker (containerization)
- Docker Compose (local orchestration)
- Kubernetes (production orchestration)
- Helm (K8s package management)

**Cloud Providers:**
- AWS (EC2, RDS, S3, VPC, etc.)
- Azure (VMs, App Service, databases)
- GCP (Compute Engine, Cloud SQL)

**Observabilidad:**
- Prometheus (metrics)
- ELK Stack (logging)
- Jaeger (distributed tracing)
- Grafana (visualization)

---

## 📚 Documentación Completa

Cada fase cuenta con documentación detallada:

| Fase | README | Objetivo | Prerequisitos |
|------|--------|----------|---------------|
| **Phase 0** | [Onboarding](./phase0-onboarding/README.md) | Setup inicial | - |
| **Phase 1** | [Linux Core](./phase1-linux-core/README.md) | Linux mastery | Phase 0 ✓ |
| **Phase 2** | [IaC](./phase2-iac/README.md) | Infraestructura como código | Phase 1 ✓ |
| **Phase 3** | [Automation](./phase3-automation/README.md) | Configuration management | Phase 2 ✓ |
| **Phase 4** | [Containers](./phase4-containers/README.md) | Containerización | Phase 3 ✓ |
| **Phase 5** | [Project](./phase5-project/README.md) | Capstone final | Phase 4 ✓ |

---

## 🤝 Contribuciones

Este repositorio es de **acceso exclusivo** para estudiantes registrados en SOFTRAINCORP. Sin embargo, las contribuciones internas son bienvenidas:

1. **Reporte de Bugs:** Abre una issue con detalles
2. **Mejoras:** Fork → rama nueva → pull request
3. **Documentación:** Correcciones y clarificaciones son esenciales

Para más detalles, consulta [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## 📞 Soporte

| Canal | Contacto | Respuesta |
|-------|----------|-----------|
| **Issues** | [GitHub Issues](../../issues) | 24-48 horas |
| **Email** | `sre-support@softraincorp.com` | 24 horas |
| **Slack** | `#sre-specialization` | En vivo |
| **Office Hours** | Viernes 10:00-11:00 UTC-3 | Semanal |

---

## ⚖️ Licencia y Acceso

```
┌──────────────────────────────────────────────────────────────────┐
│                     ACCESO EXCLUSIVO                             │
│                                                                  │
│  © 2026 SOFTRAINCORP. Todos los derechos reservados.            │
│  Este repositorio contiene material educativo propietario.      │
│  Prohibido: clonar, distribuir, vender o modificar sin         │
│  autorización explícita.                                         │
│                                                                  │
│  Acceso permitido únicamente para:                              │
│  ✓ Estudiantes activos registrados                             │
│  ✓ Instructores SOFTRAINCORP                                   │
│  ✓ Personal autorizado de auditoría                            │
│                                                                  │
│  Violaciones serán reportadas a legal@softraincorp.com          │
└──────────────────────────────────────────────────────────────────┘
```

**Licencia Completa:** [LICENSE](./LICENSE)

---

## 🎓 Estadísticas de Aprendizaje

```
📊 Contenido Total:
   • ~500+ scripts y configuraciones
   • ~100+ runbooks operacionales
   • ~50+ laboratorios prácticos
   • ~200+ horas de contenido
   
🚀 Competencias Alcanzadas:
   • Cloud Architecture (AWS, Azure, GCP)
   • SRE Enterprise-Ready
   • Infrastructure as Code Mastery
   • Automation & Orchestration
   • Observability & Monitoring
   
💼 Salidas Laborales:
   • Cloud Architect
   • DevOps Engineer
   • SRE (Site Reliability Engineer)
   • Infrastructure Engineer
   • Security Engineer (Cloud/Linux)
```

---

## 🔗 Enlaces Rápidos

- 📖 [Documentación Principal](./docs/)
- 🐛 [Reportar Bugs](../../issues/new?assignees=&labels=bug&template=bug_report.md)
- 💡 [Solicitar Mejoras](../../issues/new?assignees=&labels=enhancement&template=feature_request.md)
- 📮 [Contacto](mailto:sre-support@softraincorp.com)
- 🌐 [Web SOFTRAINCORP](https://softraincorp.com)

---

<div align="center">

### Hecho con ❤️ por **SOFTRAINCORP**

**Transforma tu carrera. Domina la infraestructura moderna. Sé un SRE de referencia.**

![Footer](https://img.shields.io/badge/Version-2.0.0-blue?style=flat-square)
![Last Updated](https://img.shields.io/badge/Updated-April%202026-brightgreen?style=flat-square)
![Status](https://img.shields.io/badge/Status-Active-success?style=flat-square)

</div>

