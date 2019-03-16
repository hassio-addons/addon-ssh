#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# Sets up a user account
# ==============================================================================
declare username
declare password

# Don't execute this when SSH is disabled
if bashio::config.false 'ssh.enable'; then
    exit 0
fi

username=$(bashio::config 'ssh.username')
username=$(bashio::string.lower "${username}")

# Create user account if the user isn't root
if [[ "${username}" != "root" ]]; then

    # Create an user account
    adduser -D "${username}" -s "/bin/sh" \
        || bashio::exit.nok 'Failed creating the user account'

    # Add new user to the wheel group
    adduser "${username}" wheel \
        || bashio::exit.nok 'Failed adding user to wheel group'

    # Ensure new user switches to root after login
    echo 'exec sudo -i' > "/home/${username}/.profile" \
        || bashio::exit.nok 'Failed configuring user profile'
fi

# We need to set a password for the user account
if bashio::config.has_value 'ssh.password'; then
    password=$(bashio::config 'ssh.password')
else
    # Use a random password in case none is set
    password=$(pwgen 64 1)
fi
chpasswd <<< "${username}:${password}" 2&> /dev/null
