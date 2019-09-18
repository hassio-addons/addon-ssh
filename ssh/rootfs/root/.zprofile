if [[ -z "$TMUX" ]]; then
	if [[ -o interactive ]]; then
                  exec tmux -u new -A -s hassio zsh
	fi
fi
