#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Executes configured customizations & persists user settings
# ==============================================================================
readonly -a DIRECTORIES=(addons backup config share ssl)
readonly SSH_USER_PATH=/data/.ssh
readonly ZSH_ENVIRONMENT_FILE=/root/.zshenv
readonly ZSH_HISTORY_FILE=/root/.zsh_history
readonly ZSH_HISTORY_PERSISTENT_FILE=/data/.zsh_history
readonly GIT_CONFIG=/data/.gitconfig

# Links some common directories to the user's home folder for convenience
for dir in "${DIRECTORIES[@]}"; do
    ln -s "/${dir}" "${HOME}/${dir}" \
        || bashio::log.warning "Failed linking common directory: ${dir}"
done

# Sets up ZSH shell
touch "${ZSH_HISTORY_PERSISTENT_FILE}" \
    || bashio::exit.nok 'Failed creating a persistent ZSH history file'

chmod 600 "$ZSH_HISTORY_PERSISTENT_FILE" \
    || bashio::exit.nok \
        'Failed setting the correct permissions to the ZSH history file'

ln -s -f "$ZSH_HISTORY_PERSISTENT_FILE" "$ZSH_HISTORY_FILE" \
    || bashio::exit.nok 'Failed linking the persistent ZSH history file'

echo "export HASSIO_TOKEN=\"${HASSIO_TOKEN}\"" > "${ZSH_ENVIRONMENT_FILE}" \
    || bashio::exit.nok 'Failed to export Hassio API token'

# Sets up the users .ssh folder to be persistent
if ! bashio::fs.directory_exists "${SSH_USER_PATH}"; then
    mkdir -p "${SSH_USER_PATH}" \
        || bashio::exit.nok 'Failed to create a persistent .ssh folder'

    chmod 700 "${SSH_USER_PATH}" \
        || bashio::exit.nok \
            'Failed setting permissions on persistent .ssh folder'
fi
ln -s "${SSH_USER_PATH}" ~/.ssh

# Sets up the user .gitconfig file to be persistent
if ! bashio::fs.file_exists "${GIT_CONFIG}"; then
    touch "${GIT_CONFIG}" \
        || bashio::exit.nok 'Failed to create .gitconfig file'
fi
ln -s "${GIT_CONFIG}" ~/.gitconfig

# Disable SSH & Web Terminal session sharing if configured
if bashio::config.false 'share_sessions'; then
    bashio::log.notice 'Session sharing has been disabled!'
    rm /root/.zprofile
fi

# Install user configured/requested packages
if bashio::config.has_value 'packages'; then
    apk update \
        || bashio::exit.nok 'Failed updating Alpine packages repository indexes'

    for package in $(bashio::config 'packages'); do
        apk add "$package" \
            || bashio::exit.nok "Failed installing package ${package}"
    done
fi

# Executes user configured/requested commands on startup
if bashio::config.has_value 'init_commands'; then
    while read -r cmd; do
        eval "${cmd}" \
            || bashio::exit.nok "Failed executing init command: ${cmd}"
    done <<< "$(bashio::config 'init_commands')"
fi
