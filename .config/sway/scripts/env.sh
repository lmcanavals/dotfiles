
# Sway stuff
export WLR_RENDERER=vulkan
export WLR_NO_HARDWARE_CURSORS=1
export XDG_CURRENT_DESKTOP=sway
if [[ "x${SWAYSOCK}x" != "xx" ]]; then
	export MOZ_ENABLE_WAYLAND=1
	export QT_QPA_PLATFORM=wayland
	export XDG_CURRENT_SESSION_TYPE=sway
fi
if [[ -d /usr/share/sway/scripts ]]; then
	PATH=/usr/share/sway/scripts:$PATH
fi

# vim: set ts=2:sw=2:noet:sts=2:
