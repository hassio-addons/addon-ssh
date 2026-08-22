# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community App: Advanced SSH & Web Terminal
# Keeps the Bash shell history around
# ==============================================================================

# The history file itself is stored on persistent storage, however, Bash only
# writes it out when a shell exits normally. Restarting or updating the app
# kills all running shells, which would throw away everything typed during
# those sessions. Appending after every command ensures the history hits the
# disk right away.
shopt -s histappend
if [[ "${PROMPT_COMMAND}" != *"history -a"* ]]; then
    PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; ${PROMPT_COMMAND}}"
fi

# The Bash defaults only keep the last 500 commands around, which is easily
# reached in a long running administrative shell. Match up with the amount
# of history ZSH keeps in this app.
HISTSIZE=50000
HISTFILESIZE=10000
