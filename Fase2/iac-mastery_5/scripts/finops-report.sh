#!/bin/bash
set -e
source ./backend-config.env

echo "=== [FINOPS] Extrayendo Pronóstico Multi-Cloud Directo desde Código HCL ==="

# Usamos la capacidad nativa de Infracost para escanear directorios de Terragrunt
# sin depender de si el plan binario tiene cambios o no.
infracost breakdown --path environments/dev/
