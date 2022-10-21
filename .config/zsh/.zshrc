#!/usr/bin/zsh

HISTFILE=$HOME/.zsh_histfile
HISTSIZE=1000
SAVEHIST=1000

export EDITOR="nvim"
export PAGER="less"
export BROWSER="exo-open --launch WebBrowser "
# unused vars: SHELL COLORTERM

if (( "x${CUSTOMZSHENV}x" == "xx" )); then
	source $ZDOTDIR/.zshenv
fi
source $ZDOTDIR/base.zsh
source $ZDOTDIR/funct.zsh
source $ZDOTDIR/aliases.zsh
[[ -s $ZDOTDIR/dynamic.zsh ]] && source $ZDOTDIR/dynamic.zsh

localismosh && export ISMOSHBRUH="yup"

if [[ ! -d $ZDOTDIR/plugins/zsh-syntax-highlighting ]]; then
	__url='https://github.com/zsh-users/zsh-syntax-highlighting.git'
	git clone --depth 1 $__url $ZDOTDIR/plugins/zsh-syntax-highlighting
	unset __url
fi
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/lmcs/Apps/c/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/lmcs/Apps/c/etc/profile.d/conda.sh" ]; then
        . "/home/lmcs/Apps/c/etc/profile.d/conda.sh"
    else
        export PATH="/home/lmcs/Apps/c/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# vim: se ts=2:sw=2:noet:sts=2
