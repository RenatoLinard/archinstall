#!/bin/bash

# ------------------------------------------------------
# Install Script for Arch Linux
# IMPORTANT: chmod +x archinstall.sh
# https://www.youtube.com/watch?v=MB-cMq8QZh4
# Wifi setup at the bottom
# ------------------------------------------------------

# ------------------------------------------------------
# CONGIG
# ------------------------------------------------------
myuser="MYUSER"
mypassword="MYPASS"

read -p "Do you want to start? " s
echo "START ARCH INSTALLATION..."

# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
echo "-> Set system time and sync with the internet"
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# ------------------------------------------------------
# Update reflector
# ------------------------------------------------------
echo "-> Update reflector"
reflector -c Germany -a 6 --sort rate --save /etc/pacman.d/mirrorlist

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
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf
echo "Keyboard layout set to German..."

# ------------------------------------------------------
# Set hostname and localhost
# ------------------------------------------------------
echo "-> Set hostname and localhost"
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
echo "-> Set root password"
passwd root

# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
echo "-> Sync package mirrors"
pacman -Syy

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
echo "-> Install packages"
pacman -S --noconfirm grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font exa bat htop ranger unzip neofetch duf xorg xorg-xinit

# ------------------------------------------------------
# Install GPU
# ------------------------------------------------------
echo "-> Install GPU"
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# ------------------------------------------------------
# Add User raabe
# ------------------------------------------------------
echo "-> Add user"
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
# Confirm grub installation
# ------------------------------------------------------
read -p "-> Do you want to install grub now?" c
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg
echo "DONE."

read -p "-> Do you want to continue?" c

# ------------------------------------------------------
# Add btrfs to mkinitcpio
# ------------------------------------------------------
echo "-> Manual step required!"
echo "Add btrfs to binaries: BINARIES=(btrfs)"
vim /etc/mkinitcpio.conf
echo "Start mkinitcpio -p linux"
mkinitcpio -p linux

# ------------------------------------------------------
# Add user to wheel
# ------------------------------------------------------
echo "-> Manual step required!"
echo "Uncomment wheel in sudoers"
sudo vim /etc/sudoers
usermod -aG wheel $my_user

echo "-> DONE! Please exit, umount -a & reboot"
echo "Activate WIFI after reboot with nmtui."
