#!/bin/bash

# Variables
ORIGEN="/home/juanmanuel"
DESTINO="/tmp"
LOG_FILE="/var/log/backup_home.log"
FECHA=$(date +%Y-%m-%d_%H-%M-%S)
NOMBRE_ARCHIVO="backup_home_$FECHA.tar.gz"
  
# 1. Crea el archivo comprimido [c: crear, z: comprimir (gzip), f: archivo, p: preservar permisos]
echo "[INFO-$(date '+%Y-%m-%d %H:%M:%S')] Iniciando respaldo de $ORIGEN..." >> "$LOG_FILE"
tar -czpf "$DESTINO/$NOMBRE_ARCHIVO" "$ORIGEN" >> "$LOG_FILE" 2>&1

# 2. Verificación
if [ $? -eq 0 ]; then
    echo "[INFO-$(date '+%Y-%m-%d %H:%M:%S')] Respaldo creado con éxito en: $DESTINO/$NOMBRE_ARCHIVO" >> "$LOG_FILE"
else
    echo "[ERROR-$(date '+%Y-%m-%d %H:%M:%S')] Hubo un error al crear el archivo de respaldo o el directorio $ORIGEN no existe." >> "$LOG_FILE"
fi
