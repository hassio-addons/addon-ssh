if [[ -z "$TMUX" ]] && [[ -o interactive ]]; then
  exec tmux -u new -A -s homeassistant zsh -l
fi
