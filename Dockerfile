# Usando la imagen específica de Ubuntu resolute-20260312 como base
FROM ubuntu:resolute-20260312

# Labels para metadata
LABEL maintainer="Juan Manuel Orgaz" \
      description="Dockerfile para una imagen de Ubuntu con Nginx y Healthcheck" \
      version="1.0" \
      os="Ubuntu Resolute 20260312"

# Establecer usuario y el directorio de trabajo
USER root
WORKDIR /root

# Evitar diálogos interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar Nginx y curl para el healthcheck
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        nginx \
        curl

# Exponer el puerto estándar
EXPOSE 80

# Copiar un archivo de configuración para Nginx ( descomentar si es necesario, de lo contrario se usará la configuración por defecto)
#COPY nginx.conf /etc/nginx/nginx.conf

# Healthcheck: verifica cada 30s si el localhost responde con éxito
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Comando para iniciar Nginx y corra en primer plano (necesario para Docker)
CMD ["nginx", "-g", "daemon off;"]