#!/usr/bin/zsh

HISTFILE=$HOME/.zsh_histfile
HISTSIZE=1000
SAVEHIST=1000

export EDITOR="nvim"
export PAGER="less"
export BROWSER="exo-open --launch WebBrowser "
# unused vars: SHELL COLORTERM

source $ZDOTDIR/base.zsh
source $ZDOTDIR/funct.zsh
source $ZDOTDIR/aliases.zsh
[[ -s $ZDOTDIR/dynamic.zsh ]] && source $ZDOTDIR/dynamic.zsh

if [[ ! -d $ZDOTDIR/plugins/zsh-syntax-highlighting ]]; then
	__url='https://github.com/zsh-users/zsh-syntax-highlighting.git'
	git clone --depth 1 $__url $ZDOTDIR/plugins/zsh-syntax-highlighting
	unset __url
fi
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

__conda_setup="$('$HOME/Apps/mc/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "$HOME/Apps/mc/etc/profile.d/conda.sh" ]; then
		source "$HOME/Apps/mc/etc/profile.d/conda.sh"
	else
		export PATH="$HOME/Apps/mc/bin:$PATH"
	fi
fi
unset __conda_setup

# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

