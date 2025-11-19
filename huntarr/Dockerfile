#============================#
#  ALEXBELGIUM'S DOCKERFILE  #
#============================#
#           _.------.  
#       _.-`    ('>.-`"""-. 
# '.--'`       _'`   _ .--.) 
#    -'         '-.-';`   ` 
#    ' -      _.'  ``'--. 
#        '---`    .-'"""` 
#               /` 
#=== Home Assistant Addon ===#

#################
# 1 Build Image #
#################

ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

# Copy Python libraries to standard location
RUN cp -a /usr/local/lib/libpython* /usr/lib/ 2>/dev/null || true && ldconfig 2>/dev/null || true

# Set Python environment variables
ENV PATH="/usr/local/bin:$PATH" \
    PYTHONPATH="/usr/local/lib/python3.9:/usr/local/lib/python3.9/lib-dynload" \
    LD_LIBRARY_PATH="/usr/local/lib:/usr/lib"

# Set working directory
WORKDIR /app

# Run Python normally
CMD ["python3", "main.py"]

############
# 5 Labels #
############

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
ENV BUILD_VERSION="${BUILD_VERSION}"
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="alexbelgium (https://github.com/alexbelgium)" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="alexbelgium (https://github.com/alexbelgium)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/alexbelgium" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

#################
# 6 Healthcheck #
#################

HEALTHCHECK \
    --interval=30s \
    --timeout=10s \
    --start-period=60s \
    --retries=3 \
    CMD curl -f http://localhost:9705/ || exit 1
