#!/bin/bash

# -----------------------------------------------------
# Arch Base Install Script with btrfs
# -----------------------------------------------------

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
echo " ------------------------------------------------------"
echo "Welcome to the arch linux install script"
echo " ------------------------------------------------------"
echo "Important: Please make sure that you have followed the manual steps in the README to partition the harddisc!"
echo ""
read -p "Do you want to start the installation now?" c

# Show partitions
lsblk
echo ""
read -p "Enter the name of the EFI partition (eg. sda1): " sda1
read -p "Enter the name of the ROOT partition (eg. sda2): " sda2
read -p "Enter the name of the VM partition (keep it empty if not required): " sda3

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
echo "-> Sync time"
timedatectl set-ntp true
echo "DONE."

# ------------------------------------------------------
# Reflector setup
# ------------------------------------------------------
echo "-> Set reflector"
reflector -c Germany -a 4 --sort rate --save /etc/pacman.d/mirrorlist
echo "DONE."

# ------------------------------------------------------
# Confirm format of partitions
# ------------------------------------------------------
read -p "Do you want to format the partitions?" c

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
echo "-> Format partitions"
mkfs.fat -F 32 /dev/$sda1
mkfs.btrfs -f /dev/$sda2
if [ -n "$sda3" ]; then
    read -p "Do you want to format the VM partition $sda3? (Enter yes. Keep it empty if no.)" fvm
    if [ -n "$fvm" ]; then
        mkfs.btrfs -f /dev/$sda3
    fi
fi
lsblk
echo "DONE."

# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
# read -p "Do you want to create the btrfs subvolumes?" c
echo "-> Create btrfs subvolumes"
mount /dev/$sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt
echo "DONE."

# ------------------------------------------------------
# Confirm the mount of drives
# ------------------------------------------------------
# read -p "Do you want to mount all drives and subvolumnes?" c
echo "-> Mount all volumes"
mount -o compress=zstd:1,noatime,subvol=@ /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/$sda2 /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/$sda2 /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/$sda2 /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/$sda2 /mnt/.snapshots
mount /dev/$sda1 /mnt/boot/efi
if [ -n "$sda3" ]; then
    mkdir /mnt/vm
    mount /dev/$sda3 /mnt/vm
fi
echo "DONE."
lsblk

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
# read -p "Do you want to install the base packages?" c
echo "-> Install base packages"
pacstrap -K /mnt base base-devel git linux linux-firmware vim openssh reflector rsync amd-ucode
echo "DONE."

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
# read -p "Do you want to generate fstab?" c
echo "-> Generate fstab"
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
echo "DONE."

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
mkdir /mnt/archinstall
cp 2-archinstall.sh /mnt/archinstall/setup.sh
cp 3-yay.sh /mnt/archinstall/install_yay.sh
cp 4-zram.sh /mnt/archinstall/install_zram.sh
read -p "Do you want to chroot to the installation and continue with 2-archinstall.sh to configure your arch installation?" c
arch-chroot /mnt ./archinstall/setup.sh
