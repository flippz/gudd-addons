#!/usr/bin/env bashio

# Set timezone if configured
if bashio::config.has_value 'TZ'; then
    export TZ=$(bashio::config 'TZ')
    bashio::log.info "Timezone set to: ${TZ}"
fi

# Export custom environment variables
if bashio::config.has_value 'env_vars'; then
    bashio::log.info "Setting custom environment variables..."
    for var in $(bashio::config 'env_vars|keys'); do
        name=$(bashio::config "env_vars[${var}].name")
        value=$(bashio::config "env_vars[${var}].value")
        bashio::log.info "Setting ${name}"
        export "${name}=${value}"
    done
fi

bashio::log.info "Starting Huntarr..."

# Start Huntarr
cd /app || exit 1
exec python3 main.py
