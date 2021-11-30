#!/bin/bash

# ------------------------------------------------------
# Install Script for Arch Linux
# IMPORTANT: chmod +x arch-install.sh
# ------------------------------------------------------

# Set System Time
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# These step needs to be done manuelly for now.
# sed -i '177s/.//' /etc/locale.gen
# locale-gen

# Set Keyboard
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf

# Set Localhost
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

# Set Root Password
echo root:password | chpasswd

# Install Packages
pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-lts-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pulseaudio xorg xorg-xinit pavucontrol bash-completion openssh rsync reflector acpi acpi_call virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font swtpm neofetch

# Install GPU
pacman -S xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Enable Services
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

# Add User raabe
useradd -m raabe
echo raabe:password | chpasswd
usermod -aG libvirt raabe

# Give sudo permissions
echo "raabe ALL=(ALL) ALL" >> /etc/sudoers.d/raabe

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
