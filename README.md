# My Arch Linux Installation Guide v8 Hyprland edition

<!--toc:start-->
- [My Arch Linux Installation Guide v8 Hyprland edition](#my-arch-linux-installation-guide-v8-hyprland-edition)
  - [Partitions](#partitions)
    - [BIOS Partition table](#bios-partition-table)
  - [Installing and setting the base system](#installing-and-setting-the-base-system)
  - [After the first reboot](#after-the-first-reboot)
    - [As user](#as-user)
      - [Colors themes and cheese](#colors-themes-and-cheese)
      - [Other classic stuff to take care of](#other-classic-stuff-to-take-care-of)
    - [As super user](#as-super-user)
      - [Updating mirror lists](#updating-mirror-lists)
  - [Tweaks and hacks](#tweaks-and-hacks)
<!--toc:end-->

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

### BIOS Partition table

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

Mount everything to /mnt:

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
pacstrap -KP /mnt base linux linux-firmware
```

chrooting into the new system:

```sh
arch-chroot /mnt
```

Installing base devel and the microcodes depending on processor:

```sh
pacman -S base-devel {amd or intel}-ucode
```

Installing some important stuff:

```sh
pacman -S \
grub grub-theme-vimix dosfstools efibootmgr \
zsh grml-zsh-config starship neovim git github-cli \
networkmanager openssh \
pacman-contrib \
terminus-font \
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
gh auth login
git clone --bare https://github.com/lmcanavals/dotfiles.git .dotfiles.git
rm .gitconfig
rm .config/gh/config.yml
git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME checkout
<c-d>
su - lmcs
dotfiles config --local core.worktree $HOME
<c-d>
cd /home/lmcs/.root/
cp etc/hostname /etc/
cp etc/locale.conf /etc/
cp etc/vconsole.conf /etc/
cp etc/mkinitcpio.conf /etc/
cp etc/default/grub /etc/default/
```

Set some configuration files for root

```sh
mkdir /root/.config
ln -s /home/lmcs/.config/starship.toml /root/.config/
```

Building the kernel image, don't forget copy the `mkinitcpio.conf` from
`.root` in case it has some cool features like early fonts fb, etc:

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
# cloning repo and cd-ing into the repo folder
mkdir -p Documents/git
cd Documents/git
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -Acsi
# delete the repo folder
```

Configure grub, copy the `/etc/default/grub` from arch-conf.git which adds the
parameters needed for hibernation support:

Speaking of hibernation, we need the UUID and offset which we can get with and we
probably want to do this afterwards from userspace:

```sh
findmnt / -o UUID -n
sudo filefrag -v /swapfile | awk '{ if($1=="0:"){print $4} }'
```

```sh
grub-install --target=x86_64-efi --efi-directory=/efi \
    --bootloader-id="Arch" --recheck --debug
grub-mkconfig -o /boot/grub/grub.cfg
```

Check for *hybrid uefi mbr*
[this link](https://wiki.archlinux.org/title/Multiboot_USB_drive)

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
# check if polkit is already installed, install it otherwise
# pick pipewire-jack as engine
sudo pacman -S \
hyprland hyprpaper wofi waybar dunst \
hyprpicker wf-recorder swappy \
xdg-desktop-portal-hyprland hypridle hyprlock gthumb kanshi zenity \
pipewire-pulse brightnessctl \
slurp grim wl-clipboard qpwgraph \
accountsservice gvfs wezterm xdg-user-dirs \
yazi unarchiver ffmpegthumbnailer zoxide \
thunar tumbler thunar-archive-plugin thunar-volman \
*cups system-config-printer gutenprint foomatic-db-gutenprint-ppds
```

Utilities

```sh
sudo pacman -S \
nwg-look tela-circle-icon-theme-orange gnome-themes-extra \
file-roller unrar p7zip ntp imagemagick \
gammastep mosh network-manager-applet pavucontrol \
keepassxc haveged jq lazygit bluez bluez-utils blueman \
firefox solaar \
bat eza fd procs sd ripgrep dust tokei bottom fzf \
qt6ct \
cmake clang \
xournalpp drawing mousepad *gopls *webp-pixbuf-loader
```

Fonts, etc:
Check if these are already installed.

- adobe-source-code-pro-fonts
- ttf-roboto
- gnu-free-fonts

```sh
sudo pacman -S \
adobe-source-han-sans-otc-fonts \
ttf-fira-code ttf-firacode-nerd ttf-roboto-mono ttf-jetbrains-mono-nerd \
ttf-liberation ttf-dejavu ttf-victor-mono-nerd \
noto-fonts-emoji ttf-croscore ttf-carlito ttf-caladea ttf-droid \
ttf-font-awesome ttf-nerd-fonts-symbols-mono font-manager \
ttf-opensans otf-monaspace # installed by telegram 
```

Stuff in case of XFCE

```sh
sudo pacman -S \
dconf-editor numlockx greetd \
slop xf86-input-wacom redshift xsel
```

Other stuff from aur

```sh
<aur helper> -S \
sound-theme-smooth hyprshade quickshell wofi-emoji zen-browser-bin
```

Fonts from aur

```sh
<aur helper> -S \
ttf-architects-daughter ttf-indieflower ttf-nothingyoucoulddo ttf-pacifico \
maplemono-nf maplemono-ttf psf-cozette ttf-fairfax-hd
```

Cloud storage, Google Drive, One Drive, etc:

```sh
sudo pacman -S rclone fuse2
```

Streaming and virtual cam stream:

```sh
sudo pacman -S obs-studio linux-headers v4l2loopback-dkms
```

Check if new versions work on wayland:

- ksnip, flameshot

Optional:

- pyright, deno, ccls, {lua,bash}-language-server # installed via mason
- kitty # now using wezterm because it's written in rust
- droidcam # android phone as webcam
- arc-solid-gtk-theme
- noto-fonts ttf-fira-mono ttf-fira-sans
- inkscape # for svg awesome
- krita # super awesome drawing tool to be used with wacom tablets
- dropbox thunar-dropbox
- steam vlc
- xf86-video-intel libva-intel-driver
- xf86-input-wacom
- nvidia nvidia-settings
- cdrkit # mkisofs, wodim and stuff

Not used anymore (maybe, some come as dependencies):

- livestreamer # to stream in VLC from twitch.tv and others
- mupen64plus # nintendo 64 emulator
- easytag # mp3 metadata editor
- hexedit # aoeu
- aria2 # download everything in style
- cmus # music player

### As user

#### Colors themes and cheese

- Bat: there is an environment variable on .zshrc.pre `BAT_THEME`, themes are on
.config/bat/themes they may need an update from time to time!
- Wezterm, stuff is in the config file
- neovim, there is a catppuccin file in after/plugin and the lazy line
- bottom is set on it's config file directly

#### Other classic stuff to take care of

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

User home directories:

Run `xdg-user-dirs-update`

### As super user

Avatar on lightdm follow instructions on this
[awesome link](https://wiki.archlinux.org/index.php/LightDM#The_AccountsService_way)
(Xfce4 rotating wallpapers overwrites `/var/lib/AccountsService/users/lmcs`,
messing up the avatar setting)

To change base configuration files:

```sh
hostnamectl set-hostname fia
localectl set-locale LANG="en_US.utf8" LC_COLLATE="C" LC_TIME="en_DK.utf8"
localectl set-x11-keymap us pc105 altgr-intl \
  grp:alt_altgr_toggle,caps:escape_shifted_capslock
timedatectl set-timezone America/Lima
```

Set ntp time sync and enabling services:

```sh
systemctl disable remote-fs.target
timedatectl set-ntp 1
systemctl enable NetworkManager.service
systemctl enable tlp
systemctl enable haveged # entropy daemon for cryptographic awesome.
```

#### Updating mirror lists

When Pacman mirror list is updated, re-generate `/etc/pacmand.d/mirrorlist`:

```sh
sudo lmcsupdatemirrors
```

Notes: Nothing for now I guess...

## Tweaks and hacks

**Fix fonts for some applications**:

```sh
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
# the next few are synced with Xfce appearance
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface font-name 'Carlito 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'Maple Mono 14'
```

Java:

Install preferably on `~/Apps`, rename from `jdk-x.x.x` to `java` then as root:

```sh
ln -s /home/lmcs/Archive/usr/java /opt/java
```
