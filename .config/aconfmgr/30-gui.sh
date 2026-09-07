if [ "${ARCH_ROLE:-desktop}" = "headless" ]; then return 0 2>/dev/null || exit 0; fi

AddPackage accountsservice
AddPackage adobe-source-han-sans-otc-fonts
AddPackage archlinux-xdg-menu
AddPackage ark
AddPackage blueman
AddPackage bluez
AddPackage bluez-utils
AddPackage brightnessctl
AddPackage cliphist
AddPackage cups
AddPackage dconf-editor
AddPackage dolphin
AddPackage dunst
AddPackage fcitx5
AddPackage fcitx5-configtool
AddPackage fcitx5-gtk
AddPackage fcitx5-qt
AddPackage ffmpegthumbnailer
AddPackage font-manager
AddPackage fuzzel
AddPackage fyi
AddPackage gnome-themes-extra
AddPackage gphoto2
AddPackage greetd
AddPackage greetd-regreet
AddPackage grim
AddPackage gvfs
AddPackage gvfs-gphoto2
AddPackage hypridle
AddPackage hyprland
AddPackage hyprlock
AddPackage hyprpaper
AddPackage hyprpicker
AddPackage hyprpolkitagent
AddPackage hyprpwcenter
AddPackage hyprsunset
AddPackage kamera
AddPackage kded
AddPackage kitty
AddPackage kvantum
AddPackage libva-utils
AddPackage mplayer
AddPackage networkmanager-dmenu
AddPackage nm-connection-editor
AddPackage noto-fonts-emoji
AddPackage nwg-look
AddPackage otf-font-awesome
AddPackage pavucontrol
AddPackage pipewire-pulse
AddPackage qalculate-qt
AddPackage qt5-wayland
AddPackage qt6-tools
AddPackage qt6ct
AddPackage showmethekey
AddPackage slurp
AddPackage speech-dispatcher
AddPackage swappy
AddPackage tela-circle-icon-theme-orange
AddPackage ttf-caladea
AddPackage ttf-carlito
AddPackage ttf-croscore
AddPackage ttf-dejavu
AddPackage ttf-fira-code
AddPackage ttf-jetbrains-mono-nerd
AddPackage ttf-liberation
AddPackage ttf-monofur-nerd
AddPackage ttf-nerd-fonts-symbols
AddPackage ttf-nerd-fonts-symbols-mono
AddPackage ttf-opensans
AddPackage ttf-roboto-mono
AddPackage ttf-ubuntu-mono-nerd
AddPackage uwsm
AddPackage v4l2loopback-dkms
AddPackage vivaldi
AddPackage vulkan-tools
AddPackage waybar
AddPackage wev
AddPackage wf-recorder
AddPackage wl-clipboard
AddPackage wtype
AddPackage xdg-desktop-portal
AddPackage xdg-desktop-portal-hyprland
AddPackage xdg-user-dirs
AddPackage xf86-input-wacom
AddPackage zenity

AddPackage --foreign hyprqt6engine
AddPackage --foreign maplemono-ttf
AddPackage --foreign rose-pine-hyprcursor
AddPackage --foreign ttf-homecomputer-sixtyfour
AddPackage --foreign ttf-jura

if lspci -k 2>/dev/null | grep -iE "vga|3d|display" | grep -iq "nvidia"; then
	AddPackage egl-wayland
	AddPackage nvidia-dkms
	AddPackage nvidia-utils
elif lspci -k 2>/dev/null | grep -iE "vga|3d|display" | grep -iqE "amd|advanced micro devices"; then
	AddPackage libva-mesa-driver
	AddPackage vulkan-radeon
elif lspci -k 2>/dev/null | grep -iE "vga|3d|display" | grep -iq "intel"; then
	AddPackage intel-media-driver
	AddPackage vulkan-intel
fi
