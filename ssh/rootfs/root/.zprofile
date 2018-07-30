if [[ -z "$TMUX" ]]; then
  exec tmux -u new -A -s hassio zsh
fi
