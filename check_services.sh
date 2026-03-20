#!/bin/bash

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