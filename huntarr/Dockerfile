#============================#
#  SIMPLE HUNTARR DOCKERFILE #
#============================#

ARG BUILD_FROM
FROM ${BUILD_FROM}

# Set environment
ENV LANG=C.UTF-8

# Install dependencies
RUN apk add --no-cache \
    bash \
    python3 \
    py3-pip \
    git \
    curl \
    tzdata \
    && pip3 install --break-system-packages --no-cache-dir \
    requests \
    flask \
    flask-cors \
    apscheduler \
    gunicorn

# Clone Huntarr
WORKDIR /app
RUN git clone --depth 1 https://github.com/plexguide/Huntarr.io.git /app && \
    rm -rf .git

# Create config directory
RUN mkdir -p /config

# Expose port
EXPOSE 9705

# Create startup script
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'echo "Starting Huntarr..."' >> /start.sh && \
    echo 'cd /app' >> /start.sh && \
    echo 'exec python3 main.py' >> /start.sh && \
    chmod +x /start.sh

# Create /init to satisfy Home Assistant
RUN ln -s /start.sh /init

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:9705/ || exit 1

CMD ["/start.sh"]

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="alexbelgium" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="alexbelgium" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/alexbelgium/hassio-addons" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
