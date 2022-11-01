export PS1='\W $ '
case "${TERM-}" in
    rxvt*|vte*|xterm*) PS1='\[\e]0;\u@\h:\w\a\]'"$PS1" ;;
esac
