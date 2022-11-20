export PS1='\W'
if [ "${USER-}" = root ]; then
    PS1="$PS1 # "
else
    PS1="$PS1 \$ "
fi
case "${TERM-}" in
    rxvt*|vte*|xterm*) PS1='\[\e]0;\u@\h:\w\a\]'"$PS1" ;;
esac
