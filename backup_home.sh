#!/bin/bash

# Variables
ORIGEN="/home/usuario"
DESTINO="/tmp"
LOG_FILE="/tmp/backup_home.log"
FECHA=$(date +%Y-%m-%d_%H-%M-%S)
NOMBRE_ARCHIVO="backup_home_$FECHA.tar.gz"
  
# 1. Crea el archivo comprimido [c: crear, z: comprimir (gzip), f: archivo, p: preservar permisos]
echo "[INFO] Iniciando respaldo de $ORIGEN..." >> "$LOG_FILE"
tar -czpf "$DESTINO/$NOMBRE_ARCHIVO" "$ORIGEN" >> "$LOG_FILE"

# 2. Verificación
if [ $? -eq 0 ]; then
    echo "[INFO] Respaldo creado con éxito en: $DESTINO/$NOMBRE_ARCHIVO" >> "$LOG_FILE"
else
    echo "[ERROR] Hubo un error al crear el archivo de respaldo o el directorio $ORIGEN no existe." >> "$LOG_FILE"
fi
