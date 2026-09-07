# --- Dynamic bootloader configuration ---

# 1. Hardware & Storage Discovery
ROOT_DEV="$(findmnt -n -o SOURCE /)"
ROOT_UUID="$(sudo blkid -s UUID -o value "$ROOT_DEV")"

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
		SWAP_UUID="$(sudo blkid -s UUID -o value "$SWAP_PATH")"
		RESUME_OPTIONS="resume=UUID=${SWAP_UUID}"
	elif [ "$SWAP_TYPE" = "file" ]; then
		SWAP_DEV="$(df --output=source "$SWAP_PATH" | tail -n 1)"
		SWAP_DEV_UUID="$(sudo blkid -s UUID -o value "$SWAP_DEV")"
		# Calculate file offset (requires root privileges)
		SWAP_OFFSET="$(sudo filefrag -v "$SWAP_PATH" 2>/dev/null | awk '{if($1=="0:"){print $4}}' | tr -d '.')"
		if [ -n "$SWAP_OFFSET" ]; then
			RESUME_OPTIONS="resume=UUID=${SWAP_DEV_UUID} resume_offset=${SWAP_OFFSET}"
		fi
	fi
fi

KERNEL_CMDLINE="root=UUID=${ROOT_UUID} rw ${RESUME_OPTIONS}"

if [ "${ARCH_ROLE:-desktop}" = "headless" ]; then
	QUIET_START=""
else
	QUIET_START="quiet loglevel=3 systemd.show_status=auto"
fi

# 2. Generate primary arch.conf
cat >"$(CreateFile /boot/loader/entries/arch.conf 700)" <<EOF
title   Arch Linux
linux   /vmlinuz-linux
${UCODE_INITRD}
initrd  /initramfs-linux.img
options ${KERNEL_CMDLINE} ${QUIET_START}
EOF

# 3. Generate fallback entry
cat >"$(CreateFile /boot/loader/entries/arch-fallback.conf 700)" <<EOF
title   Arch Linux (fallback)
linux   /vmlinuz-linux
${UCODE_INITRD}
initrd  /initramfs-linux-fallback.img
options ${KERNEL_CMDLINE}
EOF

# --- Dynamic per video card mkinitcpio configuration ---

f="$(GetPackageOriginalFile mkinitcpio /etc/mkinitcpio.conf)"
if [ "${ARCH_ROLE:-desktop}" != "headless" ]; then
	if lspci -k 2>/dev/null | grep -iE "vga|3d|display" | grep -iq "nvidia"; then
		sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/g' "$f"
		cat >"$(CreateFile /etc/modprobe.d/nvidia.conf)" <<'EOF'
options nvidia_drm modeset=1 fbdev=1
EOF
	elif lspci -k 2>/dev/null | grep -iE "vga|3d|display" | grep -iqE "amd|advanced micro devices"; then
		sed -i 's/^MODULES=()/MODULES=(amdgpu)/g' "$f"
	elif lspci -k 2>/dev/null | grep -iE "vga|3d|display" | grep -iq "intel"; then
		sed -i 's/^MODULES=()/MODULES=(i915)/g' "$f"
	fi
fi

# --- Locales ---

f="$(GetPackageOriginalFile glibc /etc/locale.gen)"
sed -i 's/^#\(en_US.UTF-8\)/\1/g' "$f"
sed -i 's/^#\(en_DK.UTF-8\)/\1/g' "$f"
sed -i 's/^#\(es_PE.UTF-8\)/\1/g' "$f"
sed -i 's/^#\(fr_FR.UTF-8\)/\1/g' "$f"
sed -i 's/^#\(pt_BR.UTF-8\)/\1/g' "$f"
