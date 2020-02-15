if [[ -z "$TMUX" ]]; then
  exec tmux -u new -A -s homeassistant bash -l
fi
