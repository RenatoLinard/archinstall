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

# Set drives
sda1="sda1"
sda2="sda2"

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

# Sync time
echo "Sync time"
timedatectl set-ntp true
sleep 3

# Reflector setup
echo "Set refelctor"
reflector -c Germany -a 6 --sort rate --save /etc/pacman.d/mirrorlist
sleep 3

# Pacman sync
echo "Update packages"
pacman -Syy
sleep 3

# Format partitions
echo "Format partitions"
mkfs.vfat -n BOOT /dev/$sda1
mkfs.btrfs -L ROOT /dev/$sda2
sleep 3

# Mount points for btrfs
echo "Create Subvolumes"
mount /dev/$sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt
sleep 3

echo "Mount subvolumes"
mount -o compress=zstd:1,noatime,subvol=@ /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log,lib/libvirt/images}}
mount -o compress=zstd:1,noatime,subvol=@cache /dev/$sda2 /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/$sda2 /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/$sda2 /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/$sda2 /mnt/.snapshots
mount /dev/$sda1 /mnt/boot/efi
sleep 3

read -p "Do you want to install the base packages?" c

# Install base packages
echo "Install base packages"
pacstrap -K /mnt base base-devel git linux linux-firmware vim openssh reflector rsync amd-ucode
sleep 3

# Change to installed sytem
read -p "Do you want to switch to the installation?" c
echo "Change to installed system"
arch-chroot /mnt

# Generate fstab
read -p "Do you want to generate fstab?" c
genfstab -U /mnt >> /mnt/etc/fstab

# Clone archinstall
git clone https://gitlab.com/stephan.raabe/archinstall.git

# Start archinstall
readm -p "Do you want to start archinstall?" c
cd archinstall
sh ./archinstall.sh

# Add btrfs to mkinitcpio
#vim /etc/mkinitcpio.conf
#BINARIES=(btrfs)
#mkinitcpio -p linux

# Install Snapper Support
#yay -S snapper-support
#sudo -s
#cd /
#umount /.snapshots
#rm -r /.snapshots
#snapper -c root create-config /
#btrfs subvol list /
#btrfs subvolume delete /.snapshots
#mkdir /.snapshots
#mount -a
#btrfs subvol get-default /
#btrfs subvol list /
#btrfs subvol set-def 256 /
#btrfs subvol get-default /
#snapper ls

# Edit Snapper Config
#vim /etc/snapper/configs/root
#ALLOW_GROUPS="wheel"
#TIMELINE_CREATE="no"
#5,5,0,0,0
#chown -R :wheel /.snapshots
#exit
#snapper ls

# Create first snapshot
#sudo -s
#cd /
#snapper -c root create -d "*** System installed ***"
#snapper ls
#systemctl status grub-btrfs-snapper.service
#exit

# Install zram
#yay -S zram-generator
#sudo vim /etc/systemd/zram-generator.conf
#Add
#[zram0]
#zram-size = ram / 2

#sudo systemctl daemon-reload
#sudo systemctl start /dev/zram0
#reboot
#free -h

# Install duf
#yay -S duf
#duf

# Rollback
#sudo -s
#snapper ls
#mount -t btrfs -o subvol=/ /dev/sda2 /mnt
#cd /mnt
#ls
#cd @
#ls
#rm -fr *
#btrfs subvolume delete /mnt/@

#btrfs subvolume snapshot /mnt/@snapshots/1/snapshot /mnt/@
#umount /mnt



#exit
#umount -a
#reboot

