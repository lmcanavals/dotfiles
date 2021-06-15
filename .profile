#!/bin/sh

# gtk doesn't work, may need to install a qt compatible theme like adwaita-qt
#export QT_STYLE_OVERRIDE=fusion

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export NO_AT_BRIDGE=1

xset -b

play "$XDG_DATA_HOME/sounds/Smooth/stereo/desktop-login.oga" &

# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

