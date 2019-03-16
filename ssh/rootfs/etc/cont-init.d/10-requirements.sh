#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: SSH & Web Terminal
# This files check if all user configuration requirements are met
# ==============================================================================

# Ensure not both web & ssh are disabled
if  bashio::config.false 'web.enable' && bashio::config.false 'ssh.enable'; then
    bashio::exit.nok 'Both SSH & Web Terminal are disabled. Aborting.'
fi

# Warn about using the root user
if bashio::config.equals 'ssh.username' 'root' \
    || bashio::config.equals 'web.username' 'root'; then
    bashio::log.warning
    bashio::log.warning 'Logging in with "root" as the username,'
    bashio::log.warning 'is security wise a bad idea!'
    bashio::log.warning
    bashio::log.warning 'Most attacks against SSH are attempts to login'
    bashio::log.warning 'using the "root" username.'
    bashio::log.warning
fi

if bashio::config.true 'ssh.enable'; then
    # Check if a username is set
    bashio::config.require.username 'ssh.username'

    # We require at least a password or a authorized key
    if bashio::config.is_empty 'ssh.authorized_keys' \
        && bashio::config.is_empty 'ssh.password';
    then
        bashio::log.fatal
        bashio::log.fatal 'Configuration of this add-on is incomplete.'
        bashio::log.fatal
        bashio::log.fatal 'Please be sure to set a least a SSH password'
        bashio::log.fatal 'or at least one authorized key!'
        bashio::log.fatal
        bashio::log.fatal 'You can configure this using the "ssh.password"'
        bashio::log.fatal 'or the "ssh.authorized_keys" option in the'
        bashio::log.fatal 'add-on configuration.'
        bashio::log.fatal
        bashio::exit.nok
    fi

    # Require a secure password
    if bashio::config.has_value 'ssh.password' \
        && ! bashio::config.true 'i_like_to_be_pwned'; then
        bashio::config.require.safe_password 'ssh.password'
    fi

    # SFTP only works if the user is root
    if bashio::config.true 'ssh.sftp' \
        && ! bashio::config.equals 'ssh.username' 'root';
    then
        bashio::log.fatal
        bashio::log.fatal 'You have enabled SFTP using the "ssh.sftp" add-on'
        bashio::log.fatal 'option. Unfortunately, this requires "ssh.username"'
        bashio::log.fatal 'to be "root".'
        bashio::log.fatal
        bashio::log.fatal 'Please change "ssh.username" to "root" or disable'
        bashio::log.fatal 'SFTP by setting "ssh.sftp" to false.'
        bashio::log.fatal
        bashio::exit.nok
    fi
fi

if bashio::config.true 'web.enable'; then

    if ! bashio::config.true 'leave_front_door_open'; then
        bashio::config.require.username 'web.username';
        bashio::config.require.password 'web.password';
    fi

    # We need a username to go with the password
    if bashio::config.is_empty 'web.username' \
        && bashio::config.has_value 'web.password';
    then
        bashio::log.fatal
        bashio::log.fatal 'You have set a Web Terminal password using the'
        bashio::log.fatal '"web.password" option, but the "web.username" option'
        bashio::log.fatal 'is left empty. Login without a username but with a'
        bashio::log.fatal 'password is not possible.'
        bashio::log.fatal
        bashio::log.fatal 'Please set a username in the "web.username" option.'
        bashio::log.fatal
        bashio::exit.nok
    fi

    # We need a password to go with the username
    if bashio::config.has_value 'web.username' \
        && bashio::config.is_empty 'web.password';
    then
        bashio::log.fatal
        bashio::log.fatal 'You have set a Web Terminal username using the'
        bashio::log.fatal '"web.username" option, but the "web.password" option'
        bashio::log.fatal 'is left empty. Login without a password but with a'
        bashio::log.fatal 'username is not possible.'
        bashio::log.fatal
        bashio::log.fatal 'Please set a password in the "web.password" option.'
        bashio::log.fatal
        bashio::exit.nok
    fi

    # Require a secure password
    if bashio::config.has_value 'web.password' \
        && ! bashio::config.true 'i_like_to_be_pwned'; then
        bashio::config.require.safe_password 'web.password'
    fi

    bashio::config.require.ssl 'web.ssl' 'web.certfile' 'web.keyfile'
fi

if bashio::config.false 'web.enable'; then
    bashio::log.notice 'The Web Terminal has been disabled!'
fi

if bashio::config.false 'ssh.enable'; then
    bashio::log.notice 'The SSH daemon has been disabled!'
fi

if bashio::config.true 'web.enable'; then
    # When Web Terminal has authentication disabled, warn!
    if bashio::config.is_empty 'web.username' \
        && bashio::config.is_empty 'web.password';
    then
        bashio::log.warning
        bashio::log.warning 'Web Terminal authentication has been disabled!'
        bashio::log.warning 'Generally, this is a bad idea!'
        bashio::log.warning
    fi
fi

# Warn about password login
if bashio::config.has_value 'ssh.password'; then
    bashio::log.warning
    bashio::log.warning \
        'Logging in with a SSH password is security wise, a bad idea!'
    bashio::log.warning 'Please, consider using a public/private key pair.'
    bashio::log.warning 'What is this? https://kb.iu.edu/d/aews'
    bashio::log.warning
fi
