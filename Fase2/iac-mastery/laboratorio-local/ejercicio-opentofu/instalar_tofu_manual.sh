#!/bin/bash
set -e

echo "=== 1. Detectando Arquitectura de la Máquina ==="
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    TOFU_ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
    TOFU_ARCH="arm64"
else
    echo "Arquitectura no soportada de forma directa: $ARCH"
    exit 1
fi

VERSION="1.8.8" # Versión estable y madura para producción
FILENAME="tofu_${VERSION}_linux_${TOFU_ARCH}.tar.gz"
# Usamos una URL de descarga alternativa que evade la redirección del dominio principal .org
URL="https://github.com/opentofu/opentofu/releases/download/v${VERSION}/${FILENAME}"

echo "=== 2. Limpiando residuos anteriores ==="
rm -f /tmp/tofu_*

echo "=== 3. Descargando paquete OpenTofu v${VERSION} ($TOFU_ARCH) ==="
# Usamos flags para ignorar errores de resolución perimetral y seguir redirecciones limpias
curl -L --fail -o "/tmp/${FILENAME}" "${URL}"

echo "=== 4. Desempaquetando e instalando en el sistema ==="
cd /tmp
tar -xzf "${FILENAME}" tofu

echo "=== 5. Moviendo binario a zona ejecutable segura ==="
sudo mv tofu /usr/local/bin/tofu
sudo chmod +x /usr/local/bin/tofu

echo "=== 6. Verificando la instalación manual ==="
if tofu --version > /dev/null 2>&1; then
    echo "--------------------------------------------------------"
    echo "¡LOGRADO! OpenTofu instalado manualmente con éxito en WSL."
    echo "Versión activa:"
    tofu --version
    echo "--------------------------------------------------------"
else
    echo "Error crítico: El binario no se pudo registrar."
    exit 1
fi
