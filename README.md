# My dot files and setup guide 2025

## From installation media

Optionally changing key maps and font:

```sh
loadkeys dvorak         # us is the default
setfont LatArCyrHeb-16  # better fonts for big monitors
```

## Partitioning

Multi boot is a thing of the past, check [legacy](legacy.md) for information.

Use `gdisk` to partition, `${diskN}` could be `sdX` or `nvme0n1` or something else.
Here we create a few variables to make the rest more generic and maybe later do an
automatic installation script.

```sh
export disk1=nvme01n1
export disk2=sda
export part1=nvme01n1p1
export part2=nvme01n1p2
export part3=sda1
export part4=sda2
```

```sh
gdisk /dev/$disk1
```

### BIOS Partition table

| Dev |  Size | Mount point              | File system | gdisk type code |
|:---:|------:|--------------------------|:-----------:|-----------------|
| SSD |  1G   | EFI System Parition      | fat32       | EF00            |
| SSD |       | `/`                      | ext4        | 8300            |
| HDD |       | `/var`                   | btrfs       | var subvol    |
| HDD |       | `/home/lmcs/archive`     | btrfs       | Archive subvol |

Swap is a file, instead of a partition, so it can be resized easily. It should
be contained in the SSD. But should only be created or activated when there are
RAM issues.

### Formatting partitions

Format partitions, for example:

```sh
mkfs.fat -F32 /dev/$part1
mkfs.ext4 /dev/$part2
```

In case we have extra storage, we can use `btrfs` or plain old `ext4`s

```sh
mkfs.btrfs -f -L Storage /dev/$disk2
btrfs subvolume create var
btrfs subvolume create Documents
```

### Mounting it all

It's recommended to have the `efi` partition on `/boot` to allow systemd-boot
to work

```sh
mount /dev/$part2 /mnt
mkdir /mnt/boot
mount -t vfat /dev/$part1 /mnt/boot
```

```sh
mount -o subvol=var /dev/$disk2 /mnt/var
mount -o subvol=Documents /dev/$disk2 /mnt/home/lmcs/Documents
```

## Installing base system

`pacstrap` helps us install the base, check `-h` to confirm the flags.

In case we are installing using `arch-install-scripts` from an existing installation
it might be recommended to create `/mnt/etc` and copy the local copy of
`vconsole.conf` and `cozette12x26` there.

```sh
pacstrap -KP /mnt base linux linux-firmware
```

`chroot` into the new system:

```sh
arch-chroot /mnt
```

Installing `base-devel` and the `microcode` depending on the processor:

```sh
pacman -S base-devel {amd or intel}-ucode
```

Installing some bare bones stuff:

```sh
pacman -S efibootmgr git github-cli neovim zsh
```

## Preparing system for `aconfmgr`

### Partition information and swap

Making swap a file lets us resize it later if needed, but need to use
`UUID` + `offset` for stuff like hibernation.

```sh
fallocate -l 32G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

Now we can generate the `fstab`. Make sure to fix any unintended values, for
example, the `UEFI` must be mounted on `/boot` for and have `{f,d}mask=0077`.

The `<ctrl+d>` part means we exit the `chroot` environment.

```sh
<ctrl-d>
genfstab -pU /mnt >> /mnt/etc/fstab
```

Afterwards maybe change to `defaults,noatime,discard` all `ssd` partitions to
reduce input output operations from frequent disk checks.

## Now the fun part

We create the user, clone a couple repos and fire `aconfmgr`, to start make
sure to `chroot` back in.

```sh
arch-chroot /mnt
```

### User creation: replicating my awesome curated setup

We create the normal user:

```sh
useradd -m -s $(which zsh) lmcs
chfn lmcs
passwd lmcs
```

Make the user owner of the `~/Documents` if it's a mounted partition.

```sh
chown -R lmcs:users /home/lmcs/Documents
```

Now we add the user to `sudoers`

```sh
EDITOR=nvim visudo
```

Add `lmcs ALL= ALL` somewhere and exit `:wq`.

### Authenticating with `github` and cloning and restoring the needed stuff

`su`ing as the normal user and authenticating:

```sh
su - lmcs
gh auth login
```

Clone and checkout the bare repository with the dot files.

```sh
git clone --bare https://github.com/lmcanavals/dotfiles.git .dotfiles.git
rm .gitconfig .config/gh/config.yml .bash*
git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME checkout
```

Clone `aconfmgr` link it and run it.

```sh
mkdir -p Apps/repos/
cd Apps/repos/
git clone --depth 1 https://github.com/CyberShadow/aconfmgr.git
<ctrl-d>
ln -s /home/lmcs/Apps/repos/aconfmgr/aconfmgr /usr/bin/
ln -s /home/lmcs/Apps/repos/aconfmgr/src/ /usr/lib/aconfmgr
su - lmcs
# cha cha chaaaan
aconfmgr apply
```

## Finishing up

Making sure the system can boot

### Don't for get to set the password for `root`

Set it like this

```sh
passwd
```

### Configuring the boot loader

```sh

```
