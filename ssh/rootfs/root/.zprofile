if [[ -z "$TMUX" ]] && [[ -o interactive ]]; then
  exec tmux -u new -A -s hassio zsh
fi
