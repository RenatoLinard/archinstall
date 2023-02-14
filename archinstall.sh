#!/bin/bash

# ------------------------------------------------------
# Install Script for Arch Linux
# IMPORTANT: chmod +x archinstall.sh
# https://www.youtube.com/watch?v=o09jzArQcFQ
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
echo "-> Set system time"
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo "Time set to Berlin and synchronized with the internet..."

# ------------------------------------------------------
# set lang utf8 US
# ------------------------------------------------------
echo "-> Set language"
echo 'LANG="en_US.UTF-8"' >> /etc/locale.conf
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "UTF-8 US in local-gen activated..."

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
echo "Hostname and localhost set..."

# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
echo "-> Set root password"
echo root:$mypassword | chpasswd
echo "Root password set..."

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
echo "-> Install packages"
pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font exa bat htop ranger unzip neofetch
echo "base packages installed..."

# ------------------------------------------------------
# Install GPU
# ------------------------------------------------------
echo "-> Install GPU"
# pacman -S xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
echo "GPU driver installed..."

# ------------------------------------------------------
# Add User raabe
# ------------------------------------------------------
echo "-> Add user"
useradd -m $myuser
echo raabe:$mypassword | chpasswd
echo "raabe ALL=(ALL) ALL" >> /etc/sudoers.d/$myuser
echo "raabe added as new user with sudo priviliges..."

# ------------------------------------------------------
# Install GRUB
# ------------------------------------------------------
echo "-> Install GRUB"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo "GRUB installed..."

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
# setup wifi 
# ------------------------------------------------------
# nmcli device wifi connect WLAN-381152 password 22036727328731084417
# nmtui

echo "DONE! You can reboot the system now..."
echo "Activate WIFI after the reboot with nmtui."
