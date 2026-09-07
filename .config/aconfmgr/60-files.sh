# --- Dynamic Bootloader Configuration ---

# 1. Hardware & Storage Discovery
ROOT_DEV="$(findmnt -n -o SOURCE /)"
ROOT_UUID="$(blkid -s UUID -o value "$ROOT_DEV")"

UCODE_INITRD=""
if grep -q "AuthenticAMD" /proc/cpuinfo; then
	UCODE_INITRD="initrd  /amd-ucode.img"
elif grep -q "GenuineIntel" /proc/cpuinfo; then
	UCODE_INITRD="initrd  /intel-ucode.img"
fi

# Detect swap for hibernation resume
RESUME_OPTIONS=""
SWAP_LINE="$(swapon --noheadings --show=NAME,TYPE 2>/dev/null | head -n 1)"
if [ -n "$SWAP_LINE" ]; then
	SWAP_PATH="$(echo "$SWAP_LINE" | awk '{print $1}')"
	SWAP_TYPE="$(echo "$SWAP_LINE" | awk '{print $2}')"

	if [ "$SWAP_TYPE" = "partition" ]; then
		SWAP_UUID="$(blkid -s UUID -o value "$SWAP_PATH")"
		RESUME_OPTIONS="resume=UUID=${SWAP_UUID}"
	elif [ "$SWAP_TYPE" = "file" ]; then
		SWAP_DEV="$(df --output=source "$SWAP_PATH" | tail -n 1)"
		SWAP_DEV_UUID="$(blkid -s UUID -o value "$SWAP_DEV")"
		# Calculate file offset (requires root privileges)
		SWAP_OFFSET="$(filefrag -v "$SWAP_PATH" 2>/dev/null | awk '{if($1=="0:"){print $4}}' | tr -d '.')"
		if [ -n "$SWAP_OFFSET" ]; then
			RESUME_OPTIONS="resume=UUID=${SWAP_DEV_UUID} resume_offset=${SWAP_OFFSET}"
		fi
	fi
fi

if [ "${ARCH_ROLE:-desktop}" = "headless" ]; then
	KERNEL_CMDLINE="root=UUID=${ROOT_UUID} rw ${RESUME_OPTIONS}"
else
	KERNEL_CMDLINE="root=UUID=${ROOT_UUID} rw ${RESUME_OPTIONS} quiet loglevel=3 systemd.show_status=auto"
fi

# 2. Generate primary arch.conf
cat >"$(CreateFile /boot/loader/entries/arch.conf 700)" <<EOF
title   Arch Linux
linux   /vmlinuz-linux
${UCODE_INITRD}
initrd  /initramfs-linux.img
options ${KERNEL_CMDLINE}
EOF

# 3. Generate fallback entry
cat >"$(CreateFile /boot/loader/entries/arch-fallback.conf 700)" <<EOF
title   Arch Linux (fallback initramfs)
linux   /vmlinuz-linux
${UCODE_INITRD}
initrd  /initramfs-linux-fallback.img
options ${KERNEL_CMDLINE}
EOF

CopyFile /boot/loader/loader.conf 700

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
CopyFile /etc/motd

gpu_modules=""
if [ "${ARCH_ROLE:-desktop}" != "headless" ]; then
	if lspci -k 2>/dev/null | grep -iE "vga|3d|display" | grep -iq "nvidia"; then
		gpu_modules="nvidia nvidia_modeset nvidia_uvm nvidia_drm"
		cat >"$(CreateFile /etc/modprobe.d/nvidia.conf)" <<'EOF'
options nvidia_drm modeset=1 fbdev=1
EOF
	elif lspci -k 2>/dev/null | grep -iE "vga|3d|display" | grep -iqE "amd|advanced micro devices"; then
		gpu_modules="amdgpu"
	elif lspci -k 2>/dev/null | grep -iE "vga|3d|display" | grep -iq "intel"; then
		gpu_modules="i915"
	fi
fi

cat >"$(CreateFile /etc/mkinitcpio.conf)" <<EOF
# vim:set ft=sh:
# MODULES
MODULES=(${gpu_modules})

# BINARIES
BINARIES=()

# FILES
FILES=()

# HOOKS
HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)
EOF

CopyFile /etc/pacman.conf
CopyFile /etc/sudoers.d/10-auth-lmcs 440
CopyFile /etc/sudoers.d/20-silence-true 440
CopyFile /etc/vconsole.conf

CreateLink /etc/localtime /usr/share/zoneinfo/America/Lima

SetFileProperty /boot mode 700
SetFileProperty /boot/loader mode 700
SetFileProperty /boot/loader/entries mode 700
