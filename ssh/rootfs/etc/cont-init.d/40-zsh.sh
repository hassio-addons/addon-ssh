#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Sets up ZSH shell
# ==============================================================================
readonly ZSH_HISTORY_FILE=/root/.zsh_history
readonly ZSH_HISTORY_PERSISTANT_FILE=/data/.zsh_history
readonly ZSH_ENVIRONMENT_FILE=/root/.zshenv

touch "${ZSH_HISTORY_PERSISTANT_FILE}" \
    || bashio::exit.nok 'Failed creating a persistent ZSH history file'

chmod 600 "$ZSH_HISTORY_PERSISTANT_FILE" \
    || bashio::exit.nok \
        'Failed setting the correct permissions to the ZSH history file'

ln -s -f "$ZSH_HISTORY_PERSISTANT_FILE" "$ZSH_HISTORY_FILE" \
    || bashio::exit.nok 'Failed linking the persistant ZSH history file'

echo "export HASSIO_TOKEN=\"${HASSIO_TOKEN}\"" > "${ZSH_ENVIRONMENT_FILE}" \
    || bashio::exit.nok 'Failed to export Hassio API token'
