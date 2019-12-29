if [[ -z "$TMUX" ]]; then
  exec tmux -u new -A -s hassio bash -l
fi
