#!/bin/bash

# ------------------------------------------------------
# Install Script for Libvirt
# ------------------------------------------------------

read -p "Do you want to start? " s
echo "START LIBVIRT INSTALLATION..."

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
echo "-> Install packages"
sudo pacman -S virt-manager qemu vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf swtpm
echo "Packages installed..."

# ------------------------------------------------------
# Edit libvirtd.conf
# ------------------------------------------------------
echo "-> Manual Steps required:"
echo "Open sudo vim /etc/libvirt/libvirtd.conf:"
echo 'Remove # at the following lines: unix_sock_group = "libvirt" and unix_sock_rw_perms = "0770"'
read -p "Press any key to open libvirtd.conf: " c
sudo vim /etc/libvirt/libvirtd.conf
sudo echo 'log_filters="3:qemu 1:libvirt"' >> /etc/libvirt/libvirtd.conf
sudo echo 'log_outputs="2:file:/var/log/libvirt/libvirtd.log"' >> /etc/libvirt/libvirtd.conf

# ------------------------------------------------------
# Add user to the group
# ------------------------------------------------------
echo "-> Add user to groups"
sudo usermod -a -G kvm,libvirt $(whoami)
echo "DONE."

# ------------------------------------------------------
# Enable services
# ------------------------------------------------------
echo "-> Enable services"
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
echo "Services enabled..."
echo "DONE."

# ------------------------------------------------------
# Edit qemu.conf
# ------------------------------------------------------
echo "Manual steps required:"
echo "Open sudo vim /etc/libvirt/qemu.conf"
echo "Uncomment and add your user name to user and group."
echo 'user = "your username"'
echo 'group = "your username"'
read -p "Press any key to open qemu.conf: " c
sudo vim /etc/libvirt/qemu.conf

# ------------------------------------------------------
# Restart Services
# ------------------------------------------------------
echo "-> Restart services"
sudo systemctl restart libvirtd
echo "DONE."

# ------------------------------------------------------
# Autostart Network
# ------------------------------------------------------
echo "-> Set network to autostart"
sudo virsh net-autostart default
echo "DONE."

echo "Please restart now with reboot."
