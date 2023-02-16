#!/bin/bash

# -----------------------------------------------------
# Arch Base Install Script 
# btrfs
# IMPORTANT: chmod +x install.sh
# -----------------------------------------------------

# -----------------------------------------------------
# Required manual steps
# -----------------------------------------------------

# Load keyboard layout
# loadkeys de

# Connect to WLAN (if not LAN)
# iwctl --passphrase 22036727328731084417 station wlan0 connect WLAN-381152

# Check internet connection
# ping -c4 www.google.de

# Check partitions
# lsblk

# Create partitions
# gdisk /dev/sda
# 1: +512M ef00 -> c: BOOT
# 2: Rest 8300 -> c: ROOT
# Write w, Confirm Y

# Install git
# pacman -S git

# -----------------------------------------------------
# Start script
# -----------------------------------------------------

# Set drives Laptop
sda1="sda1"
sda2="sda2"

# Set drives Desktop
# sda1="sda1"
# sda2="sda2"

# Confirm Start
read -p "Do you want to start the installation?" c

# Sync time
echo "Sync time"
timedatectl set-ntp true
echo "DONE."
sleep 3

# Reflector setup
echo "Set refelctor"
reflector -c Germany -a 6 --sort rate --save /etc/pacman.d/mirrorlist
echo "DONE."
sleep 3

# Pacman sync
echo "Update packages"
pacman -Syy
echo "DONE."
sleep 3

# Confirm format of partitions
read -p "Do you want to format the partitions?" c
echo "Waiting 5 sec to start..."
sleep 5

# Format partitions
echo "Format partitions"
mkfs.vfat -n BOOT /dev/$sda1
mkfs.btrfs -L ROOT /dev/$sda2
lsblk
echo "DONE."

# Confirm the creation of btrfs subvolumes
read -p "Do you want to create the btrfs subvolumes?" c
echo "Waiting 5 sec to start..."
sleep 5

# Mount points for btrfs
echo "Create Subvolumes"
mount /dev/$sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt
echo "DONE."

# Confirm the mount of drives
read -p "Do you want to mount all drives and subvolumnes?" c
echo "Waiting 5 sec to start..."
sleep 5

echo "Mount subvolumes"
mount -o compress=zstd:1,noatime,subvol=@ /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log,lib/libvirt/images}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/$sda2 /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/$sda2 /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/$sda2 /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/$sda2 /mnt/.snapshots
mount /dev/$sda1 /mnt/boot/efi
lsblk
echo "DONE."

read -p "Do you want to install the base packages?" c

# Install base packages
echo "Install base packages"
pacstrap -K /mnt base base-devel git linux linux-firmware vim openssh reflector rsync amd-ucode
sleep 3
echo "DONE."

# Change to installed sytem
read -p "Do you want to switch to the installation?" c
echo "Change to installed system"
arch-chroot /mnt
echo "DONE."

# Generate fstab
read -p "Do you want to generate fstab?" c
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
echo "DONE."

# Start archinstall
readm -p "Do you want to start the archinstall script?" c
sh ./archinstall.sh

# Confirm grub installation
read -p "Do you want to install grub now?" c
echo "Waiting 5 sec to start..."
sleep 5

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ARCHLINUX
grub-mkconfig -o /boot/grub/grub.cfg
echo "DONE."
sleep 3

read -p "Do you want to continue?" c

# Add btrfs to mkinitcpio
echo "Manual step required!"
echo "Add btrfs to binaries: BINARIES=(btrfs)"
vim /etc/mkinitcpio.conf
echo "Start mkinitcpio -p linux"
mkinitcpio -p linux

#exit
echo "DONE! Please exit, umount -a & reboot"
echo "Activate WIFI after reboot with nmtui."
