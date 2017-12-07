export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
plugins=(extract git tmux nmap rsync)
source $ZSH/oh-my-zsh.sh
#alias hadown=curl -d '{"version": "'$1'"}' http://hassio/homeassistant/update
alias haup='hassio homeassistant update'
alias halog='hassio homeassistant logs'
alias hastop='hassio homeassistant stop'
alias hastart='hassio homeassistant start'
alias harestart='hassio homeassistant restart'
alias hacheck='hassio homeassistant check'

alias supup='hassio supervisor update'
alias suplog='hassio supervisor logs'
alias supinfo='hassio supervisor info'
alias supreload='hassio supervisor reload'

alias hostup='hassio host update'
alias hostshut='hassio host shutdown'
alias hosthard='hassio host hardware'
alias hostreboot='hassio host reboot'
