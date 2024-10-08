#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# PS1='[\u@\h \W]\$ '
PS1='[${USER^}@\h \W]\$ '

export EDITOR='emacsclient -t'
export VISUAL='emacsclient -c -a emacs'

alias vi='emacsclient -t'
alias vim='emacsclient -t'
alias nvim='emacsclient -t'
