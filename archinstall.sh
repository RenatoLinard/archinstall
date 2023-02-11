#!/bin/bash

# ------------------------------------------------------
# Install Script for Arch Linux
# IMPORTANT: chmod +x archinstall.sh
# https://www.youtube.com/watch?v=o09jzArQcFQ
# ------------------------------------------------------

echo "START ARCH INSTALLATION..."

# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
echo "Time set to Berlin and synchronized with the internet..."

# ------------------------------------------------------
# set lang utf8 US
# ------------------------------------------------------
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "UTF-8 US in local-gen activated..."

# ------------------------------------------------------
# Set Keyboard
# ------------------------------------------------------
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf
echo "Keyboard layout set to German..."

# ------------------------------------------------------
# Set Localhost
# ------------------------------------------------------
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo "Localhost set..."

# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
echo root:sancho | chpasswd
echo "Root password set..."

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi acpi_call tlp virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font pip exa bat htop ranger
echo "base packages installed..."

# ------------------------------------------------------
# Install GPU
# ------------------------------------------------------
# pacman -S xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
echo "GPU driver installed..."

# ------------------------------------------------------
# Add User raabe
# ------------------------------------------------------
useradd -m raabe
echo raabe:sancho | chpasswd
usermod -aG libvirt raabe
echo "raabe ALL=(ALL) ALL" >> /etc/sudoers.d/raabe
echo "raabe added as new user with sudo priviliges..."

# ------------------------------------------------------
# Install GRUB
# ------------------------------------------------------
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo "GRUB installed..."

# ------------------------------------------------------
# Enable Services
# ------------------------------------------------------
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
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