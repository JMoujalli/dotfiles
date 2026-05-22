#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# PS1='[\u@\h \W]\$ '
PS1='[${USER^}@\h \W]\$ '

export EDITOR='emacs'
export VISUAL='emacs'

alias vi='emacs -t'
alias vim='emacs -t'
alias nvim='emacs -t'
