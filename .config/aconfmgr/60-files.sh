CopyFile /boot/loader/entries/arch-fallback.conf 700
CopyFile /boot/loader/entries/arch.conf 700
CopyFile /boot/loader/loader.conf 700
CreateDir /etc/colord '' colord colord
CopyFile /etc/greetd/config.toml
CopyFile /etc/greetd/hyprland.conf
CopyFile /etc/greetd/regreet.toml
CopyFile /etc/issue
CopyFile /etc/locale.conf
CreateLink /etc/localtime /usr/share/zoneinfo/America/Lima
CopyFile /etc/mkinitcpio.conf
CopyFile /etc/modprobe.d/v4l2loopback.conf
CopyFile /etc/modules-load.d/v4l2loopback.conf
CopyFile /etc/motd
CopyFile /etc/pacman.conf
CopyFile /etc/vconsole.conf
CopyFile /var/lib/AccountsService/icons/lmcs.png
CopyFile /var/lib/AccountsService/users/lmcs 600

SetFileProperty /boot/amd-ucode.img mode 700
SetFileProperty /boot/loader/entries mode 700
SetFileProperty /boot/loader mode 700
SetFileProperty /boot mode 700
