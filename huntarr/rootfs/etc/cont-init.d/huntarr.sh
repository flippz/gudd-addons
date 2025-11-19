#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Add-on: Huntarr
# Configures Huntarr
# ==============================================================================

bashio::log.info "Setting up Huntarr configuration..."

# Set timezone
export TZ=$(bashio::config 'TZ' 'America/New_York')

# Create config directory if it doesn't exist
mkdir -p /config

bashio::log.info "Huntarr setup complete"
