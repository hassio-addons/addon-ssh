#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: SSH & Web Terminal
# Executes configured customizations & persists user settings
# ==============================================================================
readonly -a DIRECTORIES=(addons backup config media share ssl)
readonly BASH_HISTORY_FILE=/root/.bash_history
readonly BASH_HISTORY_PERSISTENT_FILE=/data/.bash_history
readonly GIT_CONFIG=/data/.gitconfig
readonly HOME_ASSISTANT_PROFILE_D_FILE=/etc/profile.d/homeassistant.sh
readonly SSH_USER_PATH=/data/.ssh
readonly ZSH_HISTORY_FILE=/root/.zsh_history
readonly ZSH_HISTORY_PERSISTENT_FILE=/data/.zsh_history

# Links some common directories to the user's home folder for convenience
for dir in "${DIRECTORIES[@]}"; do
    ln -s "/${dir}" "${HOME}/${dir}" \
        || bashio::log.warning "Failed linking common directory: ${dir}"
done

# Sets up ZSH or Bash shell history
if bashio::config.true "zsh"; then
    touch "${ZSH_HISTORY_PERSISTENT_FILE}" \
        || bashio::exit.nok 'Failed creating a persistent ZSH history file'

    chmod 600 "${ZSH_HISTORY_PERSISTENT_FILE}" \
        || bashio::exit.nok \
            'Failed setting the correct permissions to the ZSH history file'

    ln -s -f "${ZSH_HISTORY_PERSISTENT_FILE}" "${ZSH_HISTORY_FILE}" \
        || bashio::exit.nok 'Failed linking the persistent ZSH history file'
else
    touch "${BASH_HISTORY_PERSISTENT_FILE}" \
        || bashio::exit.nok 'Failed creating a persistent Bash history file'

    chmod 600 "${BASH_HISTORY_PERSISTENT_FILE}" \
        || bashio::exit.nok \
            'Failed setting the correct permissions to the Bash history file'

    ln -s -f "${BASH_HISTORY_PERSISTENT_FILE}" "${BASH_HISTORY_FILE}" \
        || bashio::exit.nok 'Failed linking the persistent Bash history file'
fi

# Set up Bash
if ! bashio::config.true "zsh"; then
    sed -i -e 's|/zsh$|/bash|' /etc/passwd*
    sed -i -e 's|/zsh$|/bash|' /root/.tmux.conf
fi

echo "export SUPERVISOR_TOKEN=\"${SUPERVISOR_TOKEN}\"" \
    >> "${HOME_ASSISTANT_PROFILE_D_FILE}" \
        || bashio::exit.nok 'Failed to export Supervisor API token'

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
if ! bashio::config.true 'share_sessions'; then
    bashio::log.notice 'Session sharing has been disabled!'
    rm /root/.bash_profile
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
