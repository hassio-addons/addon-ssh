#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# This files check if all user configuration requirements are met
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

# Ensure not both web & ssh are disabled
if hass.config.false 'web.enable' && hass.config.false 'ssh.enable'; then
    hass.die 'Both SSH & Web Terminal are disabled. Aborting.'
fi

# Warn about using the root user
if [[ "$(hass.config.get 'ssh.username')" = 'root' ]] \
    || [[ "$(hass.config.get 'web.username')" = 'root' ]]; then
    hass.log.warning 'Logging in with root use is security wise, a bad idea!'
fi

if hass.config.true 'ssh.enable'; then
    # Check if a username is set
    if ! hass.config.has_value 'ssh.username'; then
        hass.die 'Setting a SSH username is the mandatory, when SSH is enabled!'
    fi

    # We require at least a password or a authorized key
    if ! hass.config.has_value 'ssh.authorized_keys' \
        && ! hass.config.has_value 'ssh.password';
    then
        hass.die 'Configuring a SSH password or authorized keys is mandatory!'
    fi

    # Warn about password login
    if hass.config.has_value 'ssh.password'; then
        hass.log.warning \
            'Logging in with a SSH password is security wise, a bad idea!'
        hass.log.warning 'Please, consider using a public/private key pair'
    fi

    # Require a secure password
    if hass.config.has_value 'ssh.password' \
        && ! hass.config.is_safe_password 'ssh.password'; then
        hass.die "Please choose a different SSH password, this one is unsafe!"
    fi

    # SFTP only works if the user is root
    if hass.config.true 'ssh.sftp' \
        && [[ "$(hass.config.get 'ssh.username')" != 'root' ]];
    then
        hass.die \
            'You can only enable SFTP when the SSH username is set to "root"'
    fi
fi

if hass.config.true 'web.enable'; then
    # We need a username to go with the password
    if ! hass.config.has_value 'web.username' \
        && hass.config.has_value 'web.password';
    then
        hass.die 'You have set a web password, but no web username!'
    fi

    # We need a password to go with the username
    if hass.config.has_value 'web.username' \
        && ! hass.config.has_value 'web.password';
    then
        hass.die 'You have set a web username, but no web password!'
    fi

    # Require a secure password
    if hass.config.has_value 'web.password' \
        && ! hass.config.is_safe_password 'web.password'; then
        hass.die "Please choose a different web password, this one is unsafe!"
    fi

    # When Web Terminal has authentication disabled, warn!
    if ! hass.config.has_value 'web.username' \
        && ! hass.config.has_value 'web.password';
    then
        hass.log.warning 'Web Terminal authentication has been disabled!'
        hass.log.warning 'Generally, this is a bad idea!'
    fi

    # Check SSL requirements, if enabled
    if hass.config.true 'web.ssl'; then
        if ! hass.config.has_value 'web.certfile'; then
            hass.die 'SSL is enabled, but no certfile was specified'
        fi

        if ! hass.config.has_value 'web.keyfile'; then
            hass.die 'SSL is enabled, but no keyfile was specified'
        fi

        if ! hass.file_exists "/ssl/$(hass.config.get 'web.certfile')"; then
            hass.die 'The configured certfile is not found'
        fi

        if ! hass.file_exists "/ssl/$(hass.config.get 'web.keyfile')"; then
            hass.die 'The configured keyfile is not found'
        fi
    fi
fi
