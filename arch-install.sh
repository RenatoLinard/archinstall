#!/bin/bash

# ------------------------------------------------------
# Install Script for Arch Linux
# IMPORTANT: chmod +x arch-install.sh
# https://www.youtube.com/watch?v=o09jzArQcFQ
# ------------------------------------------------------

# Set System Time
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# set lang utf8 US
sed -i '177s/.//' /etc/locale.gen
locale-gen

# Set Keyboard
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf

# Set Localhost
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

# Set Root Password
echo root:sancho | chpasswd

# Install Packages
pacman -S grub grub-customizer efibootmgr os-prober ntfs-3g networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-lts-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pulseaudio xorg xorg-xinit pavucontrol bash-completion openssh rsync reflector acpi acpi_call virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font swtpm neofetch lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings i3 terminator picom nitrogen lxappearance chromium dmenu pcmanfm exa bat

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
systemctl enable lightdm

# Add User raabe
useradd -m raabe
echo raabe:sancho | chpasswd
usermod -aG libvirt raabe

# Give sudo permissions
echo "raabe ALL=(ALL) ALL" >> /etc/sudoers.d/raabe

# setup wifi 
nmcli device wifi connect WLAN-381152 password 22036727328731084417

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
