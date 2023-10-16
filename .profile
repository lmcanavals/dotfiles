#!/bin/sh
# vim: set ts=2:sw=2:noet:sts=2:

# gtk doesn't work, may need to install a qt compatible theme like adwaita-qt
#export QT_STYLE_OVERRIDE=fusion

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export NO_AT_BRIDGE=1

export QT_QPA_PLATFORMTHEME=qt5ct

xset -b
[[ -s $HOME/.cargo/env ]] && source "$HOME/.cargo/env"

#play "$XDG_DATA_HOME/sounds/Smooth/stereo/desktop-login.oga" & 
w-cat -p "/usr/share/sounds/deepin/stereo/desktop-login.wav" &
