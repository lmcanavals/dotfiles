# vim: set ts=2:sw=2:noet:sts=2:
export ZDOTDIR=/home/lmcs/.config/zsh

if [[ -d /usr/local/go/bin ]]; then
	PATH=$PATH:/usr/local/go/bin
fi

export PATH=/home/lmcs/.local/bin:$PATH

export LCLR=$(<$ZDOTDIR/colors)

. "$HOME/.cargo/env"
