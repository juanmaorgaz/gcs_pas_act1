#!/bin/bash

# Variables
LOG_DIR="/var/log/nginx"

# Renombrar los logs actuales
mv "$LOG_DIR/access.log" "$LOG_DIR/access.$(date '+%Y%m%d%H%M%S').log"
mv "$LOG_DIR/error.log" "$LOG_DIR/error.$(date '+%Y%m%d%H%M%S').log"

# Enviar señal USR1 a Nginx para que cambie los archivos de log
kill -USR1 $(cat /var/run/nginx.pid)
# Alternativa usando el binario: nginx -s reopen