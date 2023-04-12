#!/bin/bash

#     _             _       ___           _        _ _ 
#    / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |
#   / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _` | | |
#  / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |
# /_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|
# 
# by Stephan Raabe (2023)                                                     
# -----------------------------------------------------
# Arch Base Install Script with btrfs
# -----------------------------------------------------
# NAME: ArchIntall
# DESC: An installation script for Arch Linux.
# WARNING: Run this script at your own risk.

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "by Stephan Raabe (2023)"
echo "-----------------------------------------------------"
echo ""
echo "Important: Please make sure that you have followed the "
echo "manual steps in the README to partition the harddisc!"
echo "Warning: Run this script at your own risk."
echo ""

while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo ""

# ------------------------------------------------------
# Show partitions
# ------------------------------------------------------
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
# Confirm format of partitions
# ------------------------------------------------------
read -p "Do you want to format the partitions?" c

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
while true; do
    read -p "Do you want to format the UEFI partition? Select no if Windows dual boot. (Yy/Nn)" yn
    case $yn in
        [Yy]* ) mkfs.fat -F 32 /dev/$sda1;
                break;;
        [Nn]* ) echo "You choose not to format UEFI partition.";
                break;;
        * ) echo "Please answer yes or no.";;
    esac
done

mkfs.btrfs -f /dev/$sda2

if [ -n "$sda3" ]; then
    while true; do
    	read -p "Do you want to format the VM partition? Select no if VMs exist. (Yy/Nn)" yn
    	    case $yn in
        	[Yy]* ) mkfs.btrfs -f /dev/$sda3
                    break;;
        	[Nn]* ) echo "You choose not to format VM partition.";
                    break;;
        * ) echo "Please answer yes or no.";;
        esac
    done
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
# Reflector setup
# ------------------------------------------------------
echo "-> Set reflector (can take several minutes)"
reflector -c Germany -a 2 --sort rate --save /etc/pacman.d/mirrorlist
echo "DONE."

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
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
cp 2-archinstall.sh /mnt/archinstall/setup.sh
cp 3-yay.sh /mnt/archinstall/install-yay.sh
cp 4-zram.sh /mnt/archinstall/install-zram.sh

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
echo ""
echo "Base installation DONE."
read -p "Do you want to chroot to the installation and continue with 2-archinstall.sh to configure your arch installation?" c
arch-chroot /mnt ./archinstall/setup.sh

