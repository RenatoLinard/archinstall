#!/bin/bash

#   ____             __ _                       _   _             
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/                                   
# by Stephan Raabe (2023)
# ------------------------------------------------------
# Configuration script for Arch Linux
# ------------------------------------------------------
# NAME: ArchConfiguration
# DESC: Configuration script after base installation.
# WARNING: Ru  this script at your own risk.

# ------------------------------------------------------
# CONGIG
# ------------------------------------------------------
echo ""
echo "------------------------------------------------------"
echo "START ARCH CONFIGURATION..."
echo "------------------------------------------------------"
echo ""

read -p "Enter the country for reflector (for pacman) (default: Germany): " reflector_country
if [ -z "$reflector_country" ]; then
    reflector_country="Germany"
fi

read -p "Enter the keyboard layout (default: de-latin1): " keyboard_layout
if [ -z "$keyboard_layout" ]; then
    keyboard_layout="de-latin1"
fi

read -p "Enter the zoneinfo (default: Europe/Berlin): " zone_info
if [ -z "$zone_info" ]; then
    zone_info="Europe/Berlin"
fi

read -p "Enter the hostname  (default: arch): " myhost
if [ -z "$myhost" ]; then
    myhost="arch"
fi

read -p "Enter the desired user name (no spaces and special characters): " myuser
echo ""

read -p "Do you want to start? (to cancel with strg/cmd-c)" s
echo ""

# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
echo "-> Set system time and sync with the internet"
ln -sf /usr/share/zoneinfo/$zone_info /etc/localtime
hwclock --systohc

# ------------------------------------------------------
# Update reflector
# ------------------------------------------------------
echo "-> Update reflector"
reflector -c $reflector_country -a 6 --sort rate --save /etc/pacman.d/mirrorlist

# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
echo "-> Sync package mirrors"
pacman -Syy

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
echo "-> Install packages"
pacman -S grub xdg-desktop-portal-wlr efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call dnsmasq openbsd-netcat ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font exa bat htop ranger zip unzip neofetch duf xorg xorg-xinit xclip grub-btrfs xf86-video-amdgpu xf86-video-nouveau xf86-video-intel xf86-video-qxl brightnessctl pacman-contrib

# ------------------------------------------------------
# set lang utf8 US
# ------------------------------------------------------
echo "-> Set language"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# ------------------------------------------------------
# Set Keyboard
# ------------------------------------------------------
echo "-> Set keyboard layout"
echo "FONT=ter-v18n" >> /etc/vconsole.conf
echo "KEYMAP=$keyboard_layout" >> /etc/vconsole.conf
echo "DONE."

# ------------------------------------------------------
# Set hostname and localhost
# ------------------------------------------------------
echo "-> Set hostname and localhost"
echo "$myhost" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $myhost.localdomain $myhost" >> /etc/hosts

# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
echo "-> Set root password"
passwd root

# ------------------------------------------------------
# Add User raabe
# ------------------------------------------------------
echo "-> Add user $myuser"
useradd -m -G wheel $myuser
passwd $myuser

# ------------------------------------------------------
# Enable Services
# ------------------------------------------------------
echo "-> Enable services"
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid
echo "Services enabled"

# ------------------------------------------------------
# Grub installation
# ------------------------------------------------------
# read -p "-> Do you want to install grub now?" c
echo "-> Install GRUB Bootloader"
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg
echo "DONE."

read -p "-> Do you want to continue?" c

# ------------------------------------------------------
# Add btrfs to mkinitcpio
# ------------------------------------------------------
echo "-> Manual step required!"
echo "Add btrfs to binaries (around line 10):"
echo "Before: BINARIES=()"
echo "After:  BINARIES=(btrfs)"
echo ""
read -p "Open mkinitcpio.conf now?" c
vim /etc/mkinitcpio.conf
mkinitcpio -p linux

# ------------------------------------------------------
# Add user to wheel
# ------------------------------------------------------
echo "-> Manual step required!"
echo "Uncomment %wheel group in sudoers (around line 85):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=vim sudo -E visudo
usermod -aG wheel $myuser

# ------------------------------------------------------
# Copy installation scripts to home direkctory 
# ------------------------------------------------------
cp /archinstall/install-yay.sh /home/$myuser
cp /archinstall/install-zram.sh /home/$myuser

clear
echo "-> DONE! Please exit & reboot (& remove the installation media)"
echo "Important: Activate WIFI after reboot with nmtui."
echo "After successful login as user, you can install AUR helper yay with ./install-yay.sh"
echo "You can also install zram for supporting your SSD with ./install-zram.sh (requires yay)"

