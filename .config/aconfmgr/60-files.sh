CopyFile /boot/loader/entries/arch-fallback.conf 700
if grep -q "AuthenticAMD" /proc/cpuinfo; then
	CopyFile /boot/loader/entries/arch-amd.conf 700
	CopyFile /boot/loader/loader.conf 700
elif grep -q "GenuineIntel" /proc/cpuinfo; then
	CopyFile /boot/loader/entries/arch-intel.conf 700
	cat > "$(CreateFile /boot/loader/loader.conf 700)" <<'EOF'
default  arch-intel.conf
timeout  2
console-mode auto
editor   yes
EOF
fi

if [ "${ARCH_ROLE:-desktop}" != "headless" ]; then
	CopyFile /etc/greetd/config.toml
	CopyFile /etc/greetd/hyprland.lua
	CopyFile /etc/greetd/regreet.css
	CopyFile /etc/greetd/regreet.toml
	CopyFile /etc/modprobe.d/v4l2loopback.conf
	CopyFile /etc/modules-load.d/v4l2loopback.conf
	CopyFile /var/lib/AccountsService/icons/lmcs.png
	CopyFile /var/lib/AccountsService/users/lmcs 600
fi

CopyFile /etc/issue
CopyFile /etc/locale.conf
CopyFile /etc/makepkg.conf
CopyFile /etc/makepkg.conf.d/fortran.conf
CopyFile /etc/mkinitcpio.conf
CopyFile /etc/motd
CopyFile /etc/pacman.conf
CopyFile /etc/sudoers.d/10-auth-lmcs 440
CopyFile /etc/sudoers.d/20-silence-true 440
CopyFile /etc/vconsole.conf

CreateLink /etc/localtime /usr/share/zoneinfo/America/Lima

SetFileProperty /boot mode 700
SetFileProperty /boot/loader mode 700
SetFileProperty /boot/loader/entries mode 700
