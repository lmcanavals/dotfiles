# My Arch Linux Installation Guide v7 Sway edition

Starting from installation media

```sh
loadkeys dvorak         # in case we need to change the keyboard settings
setfont LatArCyrHeb-16  # better fonts
```
Umask for group permissions
[Link here](http://unix.stackexchange.com/questions/75972/)

## Partitions

Check multiboot information about having efi and mbr boot for usb drives
[Link here](https://wiki.archlinux.org/index.php/Multiboot_USB_drive)

For regular installations:
[Check this](https://wiki.archlinux.org/index.php/Partitioning)

Using **GPT fdisk** to create partitions:

```sh
gdisk /dev/sda
```

Inside gdisk, `o` creates a GPT, `n` to create new partitions `+xxG` is
the format where xx is the size.

**BIOS Partition table**

 Dev |  Size | Mount point              | File system | gdisk type code
:---:|------:|--------------------------|:-----------:|-----------------
 SSD |  512M | EFI System Parition      | fat32       | EF00
 SSD |       | `/`                      | ext4        | 8300
 HDD |       | `/var`                   | btrfs       | var subvol
 HDD |       | `/home/lmcs/archive`     | btrfs       | Archive subvol

Swap is a file, instead of a partition, so it can be resized easily. It should
be contained in the SSD. But should only be created or activated when there are
RAM issues.

Format partitions, for example:

```sh
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.btrfs -f -L Storage /dev/sdb
btrfs subvolume create var
btrfs subvolume create Archive
```

Mount everything te /mnt:

```sh
mount -t ext4 /dev/sda2 /mnt
mkdir -p /mnt/{efi,home/lmcs/Archive/,var}
mount -t vfat /dev/sda1 /mnt/efi
mount -o subvol=var /dev/sdb /mnt/var
mount -o subvol=Archive /dev/sdb /mnt/home/lmcs/Archive
```

## Installing and setting the base system

Install base system:

```sh
pacstrap -K /mnt base linux linux-firmware
```

Chrooting into the new system:

```sh
arch-chroot /mnt
```

Installing base devel and the microdoces depeding on processor:

```sh
pacman -S base-devel {amd or intel}-ucode
```

Installing some important stuff:

```sh
pacman -S \
grub grub-theme-vimix dosfstools efibootmgr \
zsh starship neovim git github-cli \
networkmanager openssh \
pacman-contrib \
powertop tlp # for better power management
```

Create the user `lmcs`:

```sh
useradd -m -s $(which zsh) lmcs
chfn lmcs
passwd lmcs
chown -R lmcs:users /home/lmcs/Archive
```

Create swapfile:

```sh
fallocate -l 32G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

Generate `fstab`:

```sh
<c-d>
genfstab -pU /mnt >> /mnt/etc/fstab
```

Afterwards change to `defaults,noatime,discard` all ssd partitions.

Copy files and Chroot into the fresh installation:

```sh
arch-chroot /mnt
```

Set locales, uncomment `en_DK.UTF8` `en_US.UTF8` `es_PE.UTF8` on
`/etc/locale.gen`:

```sh
sed '/^#en_DK\.UTF-8/ s|#|| ' -i /etc/locale.gen
sed '/^#en_US\.UTF-8/ s|#|| ' -i /etc/locale.gen
sed '/^#es_PE\.UTF-8/ s|#|| ' -i /etc/locale.gen
locale-gen
```

Set basic configuration files:

```sh
ln -s /usr/share/zoneinfo/America/Lima /etc/localtime
su - lmcs
cd ~
git clone --bare https://github.com/lmcanavals/dotfiles.git .dotfiles.git
git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME checkout
<c-d>
cd /home/lmcs/.root/
cp etc/hostname /etc/
cp etc/locale.conf /etc/
cp etc/vconsole.conf /etc/
cp etc/mkinitcpio.conf /etc/
cp etc/default/grub /etc/default/
```

Building the kernel image, don't forget copy the `mkinitcpio.conf` from
arch-conf.git which has the hook to support hibernation:

```sh
mkinitcpio -p linux
```

Configure `sudoers` with `visudo`, add:

```sh
export EDITOR=nvim
lmcs ALL= /usr/bin/pacman
```

Install an aur helper as user, clone the repo from aur.archlinux.org then run:

```sh
su - lmcs
# cloning repo and cding into the repo folder
git clone https://aur.archlinux.org/paru-bin.git
makepkg -Acsi
# delete the repo folder
```

Configure grub, copy the `/etc/default/grub` from arch-conf.git which adds the
parameters needed for hibernation support:

```sh
grub-install --target=x86_64-efi --efi-directory=/efi \
    --bootloader-id="Arch" --recheck --debug
grub-mkconfig -o /boot/grub/grub.cfg
```

Set root password, leave chroot env, unmount and reboot:

```sh
passwd
```

Set zsh as the default shell for root:

```sh
chsh -s $(which zsh)
```

## After the first reboot

Start console session as `lmcs`

Sync, update and install the rest of the good stuff:

```sh
<aur helper> -Syu
```

GUI base:

Prefer pipewire based stuff and wireplumer.

```sh
sudo pacman -S \
sway swaybg polkit wofi waybar mako \
swayidle swaylock swayimg \
xdg-desktop-portal-wlr pipewire-pulse brightnessctl \
slurp grim wl-clipboard \
accountsservice gvfs wezterm xdg-user-dirs \
*thunar \
*cups system-config-printer gutenprint foomatic-db-gutenprint-ppds
```

Utilities

```sh
sudo pacman -S \
papirus-icon-theme \
file-roller unrar p7zip ntp imagemagick \
redshift mosh network-manager-applet pavucontrol \
gnome-keyring haveged jq \
*okular \
firefox \
*webp-pixbuf-loader \
solaar screenkey \
cmake clang *gopls \
bat eza fd procs sd ripgrep dust tokei bottom \
qt6-wayland qt6ct \
```

Fonts, utilities, etc:

```sh
sudo pacman -S \
adobe-source-han-sans-otc-fonts adobe-source-code-pro-fonts \
ttf-fira-code ttf-roboto ttf-roboto-mono ttf-jetbrains-mono-nerd \
ttf-liberation ttf-dejavu gnu-free-fonts ttf-victor-mono-nerd \
noto-fonts-emoji ttf-croscore ttf-carlito ttf-caladea \
ttf-font-awesome ttf-nerd-fonts-symbols-mono terminus-fon \
ttf-opensans # installed by telegram 
```

Cloud storage, Goodle Drive, One Drive, etc:

```sh
sudo pacman -S rclone fuse2
```

Streaming and virtual cam stream:

```sh
sudo pacman -S obs-studio linux-headers v4l2loopback-dkms
```


Optional:

* pyright, deno, ccls, {lua,bash}-language-server # installed via mason
* kitty # now using wezterm because it's written in rust
* droidcam # android phone as webcam
* arc-solid-gtk-theme
* noto-fonts ttf-fira-mono ttf-fira-sans
* inkscape # for svg awesome
* krita # super awesome drawing tool to be used with wacom tablets
* dropbox thunar-dropbox
* steam vlc
* xf86-video-intel libva-intel-driver
* xf86-input-wacom
* nvidia nvidia-settings
* cdrkit # mkisofs, wodim and stuff

Not used anymore (maybe, some come as dependencies):

* livestreamer # to stream in VLC from twitch.tv and others
* mupen64plus # nintendo 64 emulator
* easytag # mp3 metadata editor
* hexedit # aoeu
* aria2 # download everything in style
* cmus # music player

### As user

**Screen tearing on xfce**
[Source](https://techstop.github.io/fix-screen-tearing-xfce/), in short do this:

Set `vblank_mode` to `glx` on the Xfce settings editor and then,

```sh
sudo echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia-nomodeset.conf
sudo mkinitcpio -p linux
```

Make **gamastep** start on login:

```sh
systemctl --user start gammastep-indicator.service
systemctl --user enable gammastep-indicator.service
```

Setup remotes with rclone:
[OneDrive](https://www.linuxuprising.com/2018/07/how-to-mount-onedrive-in-linux-using.html)
or [OneDrive](https://rclone.org/onedrive/)
and [Google Drive](https://rclone.org/drive/)

```sh
rclone config
```

Follow instructions then create the corresponding folders, for example:

```sh
mkdir GoodleDrive
```

Then to mount the cloud remote, here `googledrive` is the remote's name:

```sh
rclone --vfs-cache-mode writes mount googledrive: ~/GoogleDrive
```


To use **droidcam** activate usb debugging on the android device developer
settings, connect the phone, open the app droidcamx (paid version for better
resolution), then open droidcam. do `adb devices` to start the server. Now you
have a virtual cam called `Droidcam` anywhere a webcam can be used.

**OBS virtual cam** obs-v4l2sink no longer needed troubleshooting: you may
need to refer to [this video](https://youtu.be/f3PWTwLlIKI) for some tips.
There are also a couple files on `/etc/modprobe.d` and `/etc/modules-load.d`

```sh
sudo modprobe v4l2loopback exclusive_caps=1 video_nr=3 card_label="OBS Stream"
```

The most beautiful command I just figured out is using `slurp` to select a
custom region anywhere in the screen. I like binding it to `Super+1`.
Check the arch wiki for it.

**npm stuff** some stuff is needed for autocomplete, link etc in neovim:

```sh
npm config set prefix '~/.local/'
npm install -g typescript typescript-language-server \
	diagnostic-languageserver eslint_d
```

**User home directories**

Run `xdg-user-dirs-update`

### As super user

Avatar on lightdm follow instructions on this 
[link](https://wiki.archlinux.org/index.php/LightDM#The_AccountsService_way)
(xfce4 rotating wallpapers overwrites `/var/lib/AccountsService/users/lmcs`,
messing up the avatar setting)

To change base configuration files:

```sh
hostnamectl set-hostname fia
localectl set-locale LANG="en_US.utf8" LC_COLLATE="C" LC_TIME="en_DK.utf8"
timedatectl set-timezone America/Lima
```

Set ntp time sync and enabling services:

```sh
systemctl disable remote-fs.target
timedatectl set-ntp 1
systemctl enable NetworkManager.service
systemctl enable tlp
systemctl enable haveged # entrophy daemon for cryptographic awesome.
```

**Updating mirrorlists**

When Pacman mirrorlist is updated, re-generate `/etc/pacmand.d/mirrorlist`:

```sh
sudo lmcsupdatemirrors
```

**Notes**

## Tweaks and hacks

**Fix fonts for some applications**:

```sh
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
# the next few are synced with xfce appearance
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface font-name 'Carlito 10'
gsettings set org.gnome.desktop.interface monospace-font-name \
'JetBrains Mono Regular 14'
```

**Java**

Install preferably on `~/Apps`, rename from `jdk-x.x.x` to `java` then as root:

```sh
ln -s /home/lmcs/Archive/usr/java /opt/java
```
