#!/bin/sh

if [ -z "$GTK_MODULES" ]
then
    GTK_MODULES="canberra-gtk-module"
else
    GTK_MODULES="canberra-gtk-module:$GTK_MODULES"
fi

export GTK_MODULES

# this should be handled by lightdm I guess
#xrandr --setprovideroutputsource modesetting NVIDIA-G0
#xrandr --auto

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

QT_STYLE_OVERRIDE=gtk
export QT_STYLE_OVERRIDE

play /home/lmcs/.local/share/sounds/Fresh\ and\ Clean/stereo/desktop-login.ogg &
# xset s off & # not needed if using presentation mode on xfce power manager
exec startxfce4

