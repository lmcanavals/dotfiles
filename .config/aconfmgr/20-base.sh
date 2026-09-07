if grep -q "AuthenticAMD" /proc/cpuinfo; then
	AddPackage amd-ucode
elif grep -q "GenuineIntel" /proc/cpuinfo; then
	AddPackage intel-ucode
fi
AddPackage base
AddPackage dosfstools
AddPackage efibootmgr
AddPackage fish
AddPackage gptfdisk
AddPackage grml-zsh-config
AddPackage linux
AddPackage linux-firmware
AddPackage linux-headers
AddPackage networkmanager
AddPackage ntp
AddPackage openssh
AddPackage pacman-contrib
AddPackage pacquery
AddPackage parallel
AddPackage pkgstats
AddPackage powertop
AddPackage socat
AddPackage sshfs
AddPackage xfsprogs
AddPackage zsh
