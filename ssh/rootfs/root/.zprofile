if ! { [[ "$TERM" = "screen" ]] && [[ -n "$TMUX" ]]; } then
  exec tmux -u new -A -s hassio zsh
fi
