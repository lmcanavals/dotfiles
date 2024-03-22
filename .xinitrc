#!/bin/sh

# remember to start xfce with startx not startxfce4, to run this cool file

QT_STYLE_OVERRIDE=gtk
export QT_STYLE_OVERRIDE

pw-cat -p /usr/share/sounds/Smooth/stereo/desktop-login.oga &

exec startxfce4

# vim: se ts=2:sw=2:noet:sts=2
