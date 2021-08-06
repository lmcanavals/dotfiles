My Arch Linux Installation Guide v5 2021
========================================

Starting from installation media

```sh
loadkeys us             # in case we need to change the keyboard settings
setfont LatArCyrHeb-16  # better fonts
```

Umask for group permissions
[Link here](http://unix.stackexchange.com/questions/75972/)

Partitions
----------

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
mkdir -p /mnt/{boot/efi,home/lmcs/Archive/,var}
mount -t vfat /dev/sda1 /mnt/boot/efi
mount -o subvol=var /dev/sdb /mnt/var
mount -o subvol=Archive /dev/sdb /mnt/home/lmcs/Archive
```

Installing and setting the base system
--------------------------------------

Install base system:

```sh
pacstrap /mnt base linux linux-firmware base-devel
```

Chrooting into the new system:

```sh
arch-chroot /mnt
```

Installing basic packages:

```sh
pacman -S \
		grub grub-theme-vimix \
		dosfstools efibootmgr \
		intel-ucode \
		zsh starship neovim git sudo \
		networkmanager \
		pacman-contrib \
		powertop tlp # for better power management
```

Create the user `lmcs`:

```sh
useradd -m -s /bin/zsh lmcs
chfn lmcs
passwd lmcs
chown -R lmcs:users /home/lmcs/Archive
```

Create swapfile:

```sh
fallocate -l 5G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

Generate `fstab`:

```sh
exit
genfstab -pU /mnt >> /mnt/etc/fstab
```

Afterwards change to `defaults,noatime,discard` all ssd partitions.

Copy files and Chroot into the fresh installation:

```sh
arch-chroot /mnt
```

Set zsh as the default shell for root:

```sh
chsh -s $(which zsh)
zsh
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
git restore --staged .
git restore .
exit
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
lmcs stella= /usr/bin/pacman
```

Download and install yay as user:

```sh
su - lmcs
cd git
git clone https://aur.archlinux.org/yay.git
cd yay
makepgk -Acsi
```

Configure grub, copy the `/etc/default/grub` from arch-conf.git which adds the
parameters needed for hibernation support:

```sh
grub-install --target=x86_64-efi --efi-directory=/boot/efi \
		--bootloader-id="Arch" --recheck --debug
grub-mkconfig -o /boot/grub/grub.cfg
```

Set root password, leave chroot env, unmount and reboot:

```sh
passwd
```

After the first reboot
----------------------

Start console session as `lmcs`

Sync, update and install the rest of the good stuff:

```sh
yay -Syu
```

GUI base:

```sh
yay -S xfce4 xfce4-goodies pulseaudio sox lightdm lightdm-gtk-greeter xcape xsel
yay -S accountsservice xorg-xmodmap xorg-server gvfs kitty ksnip
```

Graphics nvidia:

```sh
yay -S nvidia nvidia-settings xorg-xrandr
```

Utilities

```sh
yay -S papirus-icon-theme
yay -S file-roller unrar p7zip ntp imagemagick htop
yay -S redshift mosh network-manager-applet pavucontrol
yay -S libcanberra gnome-keyring haveged jq
yay -S firefox google-chrome opera opera-ffmpeg-codecs
yay -S webp-pixbuf-loader solaar screenkey slop
yay -S cmake ccls deno gopls pyright tree-sitter fzf
yay -S bat exa fd procs sd ripgrep dust tokei bottom
```

Fonts, utilities, etc:

```sh
yay -S adobe-source-code-pro-fonts # if not installed already
yay -S adobe-source-han-sans-otc-fonts
yay -S ttf-fira-code
yay -S ttf-roboto ttf-roboto-mono
yay -S ttf-liberation ttf-dejavu gnu-free-fonts
yay -S noto-fonts-emoji ttf-croscore ttf-carlito ttf-caladea
yay -S ttf-opensans # installed by telegram
yay -S ttf-font-awesome ttf-nerd-fonts-symbols-mono
```

Cloud storage, Goodle Drive, One Drive, etc:

```sh
yay -S rclone fuse2
```

Streaming and virtual cam stream:

```sh
yay -S obs-studio linux-headers v4l2loopback-dkms
```

Use a wacom tablet:

```sh
yay -S xf86-input-wacom
```

Optional:

* droidcam # android phone as webcam
* arc-solid-gtk-theme
* adobe-source-sans-pro-fonts
* adobe-source-serif-pro-fonts
* noto-fonts ttf-fira-mono ttf-fira-sans
* inkscape # for svg awesome
* krita # super awesome drawing tool to be used with wacom tablets
* dropbox thunar-dropbox
* steam openssh vlc
* xf86-input-synaptics # duh
* xf86-video-intel libva-intel-driver
* cdrkit # mkisofs, wodim and stuff
* glew glfw glm # for the opengl experience

Not used anymore (maybe, some come as dependencies):

* wqy-microhei wqy-zenhei wqy-bitmapsong-beta
* ttf-wqy-microhei-ibx ttf-roboto-ibx ttf-dejavu
* haveged # random number generator, can't remember what for
* livestreamer # to stream in VLC from twitch.tv and others
* mupen64plus # nintendo 64 emulator
* easytag # mp3 metadata editor
* hexedit # aoeu
* aria2 # download everything in style
* cmus # music player

Important
---------

### As user

**Screen tearing on xfce**
[Source](https://techstop.github.io/fix-screen-tearing-xfce/), in short do this:

Set `vblank_mode` to `glx` on the Xfce settings editor and then,

```
sudo echo "options nvidia-drm modset=1" > /etc/modprobe.d/nvidia-nomodset.conf
sudo mkinitcpio -p linux
```

Make **redshift-gtk** start on login:

```sh
systemctl --user start redshift-gtk.service
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

When using a wacom tablet with a dual monitor setup, this commands help:

```sh
xsetwacom list devices
```

Then use the name or id of the `stylus` to set the area on 1 monitor only, for
most drivers using the monitor's name shown by `xrandr` works, for nvidia 
`HEAD-0` or `HEAD-1` might work instead, in the next example 10 is the ID of the
`stylus`. More information can be found on the Archlinux wiki entry for Wacom.

```sh
xsetwacom set 10 MapToOutput HEAD-0
```

**npm stuff** some stuff is needed for autocomplete, link etc in neovim:

```sh
npm config set prefix '~/.local/'
npm install -g typescript typescript-language-server \
	diagnostic-languageserver eslint_d
```

**User home directories**

Run `xdg-user-dirs-update`

### As super user

**Configure nvidia**, copy the following files:

```sh
/etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
/etc/lightdm/display_setup.sh
```

Make the `display_setup.sh` executable:

```sh
chmod +x /etc/lightdm/display_setup.sh
```

Edit `/etc/lightdm/lightdm.conf`, look for `[Seat:*]` then
`#display-setup-script=` and change to:

```sh
display-setup-script=/etc/lightdm/display_setup.sh
```

More info about nvidia can be found
[here for optimus](ihttps://wiki.archlinux.org/index.php/NVIDIA_Optimus)
and [here](https://wiki.archlinux.org/index.php/NVIDIA)

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

* .xinitrc needed only for old school desktop managers like slim
* .xresources needed only when starting stuff by hand (no xfsettingsd)

Tweaks and hacks
----------------

**Caps Lock to control**

Taken care by dotfiles.git

**Fix fonts for some applications**:

```sh
gsettings set org.gnome.desktop.interface font-name 'Open Sans 10'
gsettings set org.gnome.desktop.interface monospace-font-name \
	'Cascadia Code PL Semi-Light 14'
```

**Java**

Install preferably on `~/Archive/usr`, rename from `jdk-x.x.x` to `java`
then as root:

```sh
ln -s /home/lmcs/Archive/usr/java /opt/java
```
