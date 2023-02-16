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
# loadkeys de-latin1

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

# Sync package

# Pacman sync packages
# pacman -Syy

# Install git
# pacman -S git

# Clone Installation
# git clone https://gitlab.com/stephan.raabe/archinstall.git

# -----------------------------------------------------
# Start script
# -----------------------------------------------------

# Set drives Laptop
sda1="sda1"
sda2="sda2"

# Set drives Desktop
# sda1="sda1"
# sda2="sda2"

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
read -p "Do you want to start the installation?" c

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
echo "Sync time"
timedatectl set-ntp true
echo "DONE."

# ------------------------------------------------------
# Reflector setup
# ------------------------------------------------------
echo "Set reflector"
reflector -c Germany -a 6 --sort rate --save /etc/pacman.d/mirrorlist
echo "DONE."

# ------------------------------------------------------
# Confirm format of partitions
# ------------------------------------------------------
read -p "Do you want to format the partitions?" c
echo "Waiting 3 sec to start..."
sleep 3

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
echo "Format partitions"
mkfs.fat -F 32 /dev/$sda1
mkfs.btrfs -f /dev/$sda2
lsblk
echo "DONE."

# ------------------------------------------------------
# Confirm the creation of btrfs subvolumes
# ------------------------------------------------------
read -p "Do you want to create the btrfs subvolumes?" c
echo "Waiting 3 sec to start..."
sleep 3

# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
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
read -p "Do you want to mount all drives and subvolumnes?" c
echo "Waiting 3 sec to start..."
sleep 3

mount -o compress=zstd:1,noatime,subvol=@ /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log,lib/libvirt/images}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/$sda2 /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/$sda2 /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/$sda2 /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/$sda2 /mnt/.snapshots
mount /dev/$sda1 /mnt/boot/efi
lsblk
echo "DONE."

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
read -p "Do you want to install the base packages?" c
echo "Install base packages"
pacstrap -K /mnt base base-devel git linux linux-firmware vim openssh reflector rsync amd-ucode
echo "DONE."

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
read -p "Do you want to generate fstab?" c
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
echo "DONE."

# ------------------------------------------------------
# Change to installed sytem
# ------------------------------------------------------
read -p "Do you want to switch to the installation? You have to clone the installer again." c
arch-chroot /mnt