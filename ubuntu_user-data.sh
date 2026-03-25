#!/bin/bash

# Instalar Nginx y el CLI de AWS
apt update -y
apt install -y nginx unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Arranque de Nginx
systemctl start nginx
systemctl enable nginx

# Borrar el directorio web por defecto
rm -rf /var/www/html/*

# Descargar el contenido desde el Bucket de S3
aws s3 sync s3://juanmaorgaz-web/web/ /var/www/html/

# Remplazar permisos para que el servidor web pueda leer los archivos copiados desde S3
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html/

# Script para verificar los servicios
cat << 'EOF' > /usr/local/bin/check_services.sh
# Variables
SERVICIOS=("nginx" "ssh")
LOG_FILE="/var/log/servicios_report.log"

# Verificación
for servicio in "${SERVICIOS[@]}"; do  # Recorre cada servicio
    echo "[INFO-$(date '+%Y-%m-%d %H:%M:%S')] Verificando servicio $servicio..." >> "$LOG_FILE"
    
    ESTADO=$(systemctl is-active "$servicio")
    if [ "$ESTADO" == "active" ]; then
        echo "[INFO-$(date '+%Y-%m-%d %H:%M:%S')] El servicio $servicio está activo." >> "$LOG_FILE"
    else
        echo "[ERROR-$(date '+%Y-%m-%d %H:%M:%S')] El servicio $servicio no está activo, intentando iniciarlo..." >> "$LOG_FILE"
        systemctl start "$servicio" >> "$LOG_FILE" 2>&1
        if [ $? -eq 0 ]; then
            echo "[INFO-$(date '+%Y-%m-%d %H:%M:%S')] El servicio $servicio se ha iniciado correctamente." >> "$LOG_FILE"
        else
            echo "[ERROR-$(date '+%Y-%m-%d %H:%M:%S')] No se ha podido iniciar el servicio $servicio." >> "$LOG_FILE"
        fi
    fi
done
EOF
chmod +x /usr/local/bin/check_services.sh

# Configurar cron para ejecutar el script de verificación cada 5 minutos
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/check_services.sh") | crontab -


