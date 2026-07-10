# Laboratorio de Gobernanza Avanzada Multiambiente con IaC

[![OpenTofu](https://img.shields.io/badge/OpenTofu-1.10%2B-844FBA?style=flat-square&logo=opentofu&logoColor=white)](https://opentofu.org/)
[![Terragrunt](https://img.shields.io/badge/Terragrunt-DRY_IaC-5C4EE5?style=flat-square&logo=terraform&logoColor=white)](https://terragrunt.gruntwork.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud_Provider-FF9900?style=flat-square&logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![TFLint](https://img.shields.io/badge/TFLint-Linter-2C3E50?style=flat-square)](https://github.com/terraform-linters/tflint)
[![TFSec](https://img.shields.io/badge/TFSec-SAST_Security-E74C3C?style=flat-square)](https://github.com/aquasecurity/tfsec)
[![Infracost](https://img.shields.io/badge/Infracost-FinOps-00D2B4?style=flat-square)](https://www.infracost.io/)
[![License](https://img.shields.io/badge/Licencia-Educativa-lightgrey?style=flat-square)]()

Este repositorio reúne un entorno de laboratorio pensado para practicar, de forma guiada, un pipeline completo de validación estática y gobernanza sobre Infraestructura como Código (IaC). El stack principal combina **OpenTofu / Terraform (v1.10 o superior)** y **Terragrunt** para orquestar recursos en Amazon Web Services (AWS) de manera segura, ordenada y sin duplicar configuración, siguiendo el principio DRY (*Don't Repeat Yourself*).

La idea central del laboratorio es simple: antes de que cualquier recurso toque la nube, el código pasa por tres filtros independientes que revisan estilo, costo y seguridad. Este documento explica qué hace cada herramienta, por qué está en ese orden y cómo reproducir el flujo completo paso a paso.

## Tabla de contenidos

- [Herramientas de la suite de auditoría](#herramientas-de-la-suite-de-auditoría)
- [De tfsec a Trivy: hacia dónde va el ecosistema](#de-tfsec-a-trivy-hacia-dónde-va-el-ecosistema)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Flujo de trabajo paso a paso](#flujo-de-trabajo-paso-a-paso)
- [Buenas prácticas recomendadas](#buenas-prácticas-recomendadas)
- [Público objetivo](#público-objetivo)

## Herramientas de la suite de auditoría

El pipeline de este laboratorio no depende de una sola herramienta, sino de tres capas de control que se complementan entre sí. Cada una responde a una pregunta distinta sobre la infraestructura antes de que se despliegue.

### 1. TFLint: el linter sintáctico

TFLint es la primera línea de defensa. Revisa que el código HCL siga buenas prácticas de estilo, detecta errores específicos del proveedor de AWS (por ejemplo, tipos de instancia inválidos) y encuentra fallos que el propio compilador de Terraform normalmente no reporta hasta el momento del apply.

Se ejecuta justo después de escribir o modificar cualquier archivo de configuración, como parte natural del ciclo de edición. Es rápido, barato en tiempo de cómputo y evita que errores triviales lleguen a etapas posteriores del pipeline.

### 2. Infracost: gobernanza FinOps

Infracost analiza los archivos de configuración y genera una estimación detallada del impacto financiero mensual que tendrá el nuevo despliegue en la factura de AWS.

Su lugar en el flujo es antes de cualquier plan o apply, de modo que el equipo pueda validar si el presupuesto asignado al proyecto sigue siendo viable. En un contexto de aprendizaje, esta herramienta ayuda a construir el hábito de pensar en costos como parte del diseño, no como una sorpresa al final del mes.

### 3. TFSec: el escáner de seguridad SAST

TFSec realiza un análisis estático de seguridad orientado a detectar configuraciones inseguras: brechas perimetrales, buckets de S3 expuestos públicamente, ausencia de cifrado en reposo, políticas de IAM demasiado permisivas, entre otros patrones de riesgo conocidos.

Se ejecuta justo antes del despliegue, funcionando como el guardián de cumplimiento (compliance) de la cuenta. Ningún recurso debería llegar a producción sin pasar por este control.

## De tfsec a Trivy: hacia dónde va el ecosistema

Nota de ingeniería de plataforma, 2026.

Este laboratorio utiliza el binario tradicional de tfsec por motivos didácticos, ya que permite observar de forma aislada el comportamiento del escáner de seguridad. Sin embargo, es importante que quien complete este laboratorio conozca el contexto actual de la herramienta: tfsec fue integrado oficialmente dentro de Trivy, el proyecto de Aqua Security.

Mientras que tfsec se limita exclusivamente al análisis de archivos con extensión .tf, Trivy actúa como un escáner de seguridad universal. Hereda por completo el conjunto de reglas de evaluación de tfsec y además extiende la auditoría hacia imágenes de contenedores Docker, manifiestos de Kubernetes, detección de secretos expuestos en el código y análisis de vulnerabilidades conocidas (CVEs) en dependencias de software.

En los pipelines corporativos modernos, la tendencia es clara: la mayoría de los equipos ya se está moviendo hacia el uso exclusivo del comando `trivy config .` en lugar de invocar tfsec de forma independiente. Vale la pena practicar ambos enfoques para entender por qué ocurrió esta consolidación de herramientas.

## Estructura del repositorio

```text
.
├── root.hcl                     # Configuración global y backend remoto (S3 Native Locking)
├── modules/
│   └── s3_app/                  # Módulo base de la aplicación (bucket S3 condicional)
│       └── main.tf
├── environments/
│   ├── dev/                     # Entorno de desarrollo (inyección de variables locales)
│   │   └── terragrunt.hcl
│   └── prod/                    # Entorno de producción (blindado por defecto)
│       └── terragrunt.hcl
├── scripts/
│   ├── create_backend.sh        # Inicializador idempotente del backend de estado en S3
│   ├── destroy_backend.sh       # Purga de versiones de S3 y remoción del backend
│   └── audit_infrastructure.sh  # Script de detección de recursos activos en AWS
└── laboratorios_previos/        # Respaldo de archivos históricos del curso
```

Cada carpeta cumple una función concreta dentro del laboratorio:

- **root.hcl** centraliza la configuración de Terragrunt para evitar repetirla en cada entorno.
- **modules/s3_app** contiene la lógica reutilizable del bucket S3, incluyendo el interruptor `vulnerable_mode` que se usa para practicar la detección de fallos de seguridad.
- **environments/** separa dev y prod, de modo que cada entorno pueda tener su propia configuración sin tocar el módulo base.
- **scripts/** automatiza las tareas de infraestructura de soporte (backend remoto) y de auditoría forense posterior al despliegue.

## Flujo de trabajo paso a paso

Para reproducir este laboratorio o validar cambios sin generar condiciones de carrera ni desajustes de estado (drift), es importante seguir este orden de forma estricta. Cada fase depende de que la anterior haya terminado correctamente.

### Fase 1: inicialización de la arquitectura de soporte

Posiciónate en la raíz del proyecto y levanta el backend centralizado de estados remotos, con bloqueo nativo de S3 (sin necesidad de DynamoDB):

```bash
./scripts/create_backend.sh
```

### Fase 2: ciclo de validación en el entorno de desarrollo

Muévete al directorio del entorno de desarrollo:

```bash
cd environments/dev
```

Como ejercicio de práctica, configura `vulnerable_mode = true` en el módulo base y observa cómo tfsec detiene el pipeline al reportar alertas críticas:

```bash
tfsec .terragrunt-cache/
```

Aplica la mitigación correspondiente, ajustando `vulnerable_mode = false` tanto en el `terragrunt.hcl` del entorno como en el valor por defecto del módulo. Luego limpia las cachés, refresca el entorno y confirma que el pipeline queda en verde:

```bash
rm -rf .terragrunt-cache/ .infracost/
terragrunt init
tfsec .terragrunt-cache/
```

Si todo salió bien, deberías ver el mensaje de "sin problemas detectados" antes de continuar a la siguiente fase.

### Fase 3: despliegue y auditoría activa

Con la validación en verde, aplica la infraestructura aprobada:

```bash
terragrunt apply --auto-approve
```

Verifica de forma independiente que los recursos quedaron realmente activos en la cuenta, usando el script forense:

```bash
../../scripts/audit_infrastructure.sh
```

Este paso es clave para el aprendizaje: no basta con confiar en la salida de Terragrunt, sino que conviene comprobar el estado real de los recursos desde afuera del pipeline.

### Fase 4: desmantelamiento antidegradación

Destruye primero los recursos de la aplicación, para evitar dejar recursos huérfanos o "zombis":

```bash
terragrunt destroy --auto-approve
```

Regresa a la raíz del proyecto y elimina el backend, limpiando también su historial de versiones indexadas:

```bash
cd ../..
./scripts/destroy_backend.sh
```

Por último, certifica que la cuenta de AWS quedó completamente limpia, ejecutando de nuevo el script de auditoría:

```bash
./scripts/audit_infrastructure.sh
```

## Buenas prácticas recomendadas

- Ejecuta TFLint apenas termines de editar cualquier archivo HCL; corregir errores pequeños al momento es mucho más barato que arrastrarlos hasta el plan o el apply.
- No saltees la fase de Infracost solo porque el entorno es de desarrollo. Acostumbrarse a revisar el costo estimado es un hábito que se traslada directamente a producción.
- Trata cada alerta de TFSec como un caso de estudio, no como un obstáculo. Entender por qué una configuración es insegura vale más que simplemente silenciar la regla.
- Considera migrar los comandos de este laboratorio hacia `trivy config .` una vez que te sientas cómodo con el flujo tradicional de tfsec, para familiarizarte con la herramienta que está reemplazando gradualmente al binario original.
- Nunca destruyas el backend antes que los recursos de la aplicación; el orden de la Fase 4 evita dejar infraestructura huérfana en la cuenta.

## Público objetivo

Este material fue preparado como documentación de control de calidad técnica para la Especialización SRE Linux. Está pensado tanto para quienes se acercan por primera vez a Terragrunt y a los escáneres de seguridad estática, como para quienes ya conocen el ecosistema y buscan un entorno de práctica reproducible antes de llevar estos controles a un pipeline productivo.

