#!/bin/bash
# revert_and_clean_lab.sh - Revierte el laboratorio SRE y reinstala Nginx limpio.
# Ejecutar como: sudo bash revert_and_clean_lab.sh

set -e  # Opcional: salir si hay error grave; puedes comentarlo

echo "=== Iniciando reversión + reinstalación limpia del laboratorio SRE ==="

# 1. Detener y deshabilitar nginx
if systemctl is-active --quiet nginx; then
    echo "Deteniendo nginx..."
    systemctl stop nginx
fi
if systemctl is-enabled --quiet nginx 2>/dev/null; then
    echo "Deshabilitando nginx..."
    systemctl disable nginx
fi

# 2. Eliminar override de systemd (hardening)
if [ -d /etc/systemd/system/nginx.service.d ]; then
    echo "Eliminando override de systemd..."
    rm -rf /etc/systemd/system/nginx.service.d
    systemctl daemon-reload
fi

# 3. Eliminar virtual host y enlaces
echo "Eliminando configuración del sitio sre-lab..."
rm -f /etc/nginx/sites-enabled/sre-lab
rm -f /etc/nginx/sites-available/sre-lab

# Restaurar site default si existe algún backup (para dejar algo funcional)
latest_bkp=$(ls -td /var/backups/nginx_* 2>/dev/null | head -1)
if [ -n "$latest_bkp" ] && [ -f "$latest_bkp/default" ]; then
    echo "Restaurando site default desde backup: $latest_bkp/default"
    cp "$latest_bkp/default" /etc/nginx/sites-available/default
    if [ ! -L /etc/nginx/sites-enabled/default ]; then
        ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
    fi
else
    # Si no hay backup, aseguramos que exista al menos un default funcional
    if [ -f /etc/nginx/sites-available/default ]; then
        ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
    fi
fi

# 4. Eliminar contenido web y usuario
echo "Eliminando directorio web y usuario webapp..."
rm -rf /var/www/sre-lab
if id "webapp" &>/dev/null; then
    userdel -r webapp 2>/dev/null || userdel webapp
fi

# 5. Eliminar archivo .htpasswd
rm -f /etc/nginx/.htpasswd

# 6. Eliminar logs personalizados
rm -f /var/log/nginx/sre-lab.access.json
rm -f /var/log/nginx_health.log

# 7. Eliminar script de health check y cron
rm -f /usr/local/bin/check_nginx_health.sh
rm -f /etc/cron.d/nginx_health

# 8. Eliminar directorio cache de nginx
rm -rf /var/cache/nginx

# 9. Restaurar nginx.conf original desde backup si existe
if [ -n "$latest_bkp" ] && [ -f "$latest_bkp/nginx.conf" ]; then
    echo "Restaurando nginx.conf original desde backup..."
    cp "$latest_bkp/nginx.conf" /etc/nginx/nginx.conf
else
    echo "No se encontró backup de nginx.conf. Limpiando personalizaciones..."
    # Eliminar bloque json_analytics y server_tokens off si existen
    sed -i '/^ *log_format json_analytics/,/^ *\}/d' /etc/nginx/nginx.conf
    sed -i '/^ *server_tokens off;/d' /etc/nginx/nginx.conf
fi

# 10. Purgar y reinstalar Nginx limpio (dejar como recién instalado)
echo "Purga completa de Nginx y dependencias..."
apt purge --auto-remove -y nginx nginx-common apache2-utils curl

echo "Reinstalando paquetes necesarios para el laboratorio..."
apt update
apt install -y nginx apache2-utils curl

# 11. Asegurar que el servicio está habilitado y arranca por defecto (estado limpio)
systemctl enable nginx
systemctl start nginx

# 12. Verificar que Nginx funciona con la configuración por defecto
echo "Verificando instalación limpia..."
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx está activo con configuración por defecto."
else
    echo "⚠️ Nginx no está activo. Revisar con 'systemctl status nginx'."
fi

echo "=== Reversión y reinstalación completada. El sistema está limpio para repetir el laboratorio. ==="
echo "Puedes ejecutar el runbook desde el paso 1."
