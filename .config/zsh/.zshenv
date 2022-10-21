# vim: set ts=2:sw=2:noet:sts=2:

if (( "x${CUSTOMZSHENV}x" == "xx" )); then
	export CUSTOMZSHENV="X"
fi

export ZDOTDIR=/home/lmcs/.config/zsh

if [[ -d /usr/local/go/bin ]]; then
	PATH=$PATH:/usr/local/go/bin
fi

PATH=/home/lmcs/.local/bin:$PATH
typeset -U PATH
export PATH

export LCLR=$(<$ZDOTDIR/colors)

[[ -f "$HOME/.cargo/env" ]] && \
. "$HOME/.cargo/env"
