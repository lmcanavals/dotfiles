#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
export PATH="/home/lmcs/.local/bin:$PATH"
