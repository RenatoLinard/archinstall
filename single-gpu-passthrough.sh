#!/bin/bash

# https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/1)-Preparations
# https://github.com/QaidVoid/Complete-Single-GPU-Passthrough

# sudo vim /etc/default/grub
# GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 amd_iommu=on iommu=pt pci=noats video=efifb:off"
# sudo grub-mkconfig -o /boot/grub/grub.cfg
# reboot

# check that iommu groups are valid with iommu.sh
sudo pacman -S virt-manager qemu vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf

printf "uncommend the the follow lines: # unix_sock_group = libvirt and # unix_sock_rw_perms = 0770"
sudo vim /etc/libvirt/libvirtd.conf

# add this at the bottom for log files
# log_filters="1:qemu"
# log_outputs="1:file:/var/log/libvirt/libvirtd.log"

printf "edit the following lines user = 'raabe' and group = 'raabe'"
sudo vim /etc/libvirt/qemu.conf

sudo systemctl restart libvirtd

# VGA bios was not required because of AMD GPU

# Vendor-Reset required beause of AMD rest bug
# git clone https://github.com/gnif/vendor-reset.git
# sudo pacman -S git dkms base-devel linux-headers

# https://www.reddit.com/r/VFIO/comments/khacye/is_there_an_idiotproof_guide_on_how_to_setup_the/
# sudo echo "vendor-reset" | sudo tee /etc/modules-load.d/vendor-reset.conf
# sudo dkms install .
# Add vendor reset to kernel modules (after btrf)
# sudo vim /etc/mkinitcpio.conf
# sudo mkinitcpio -p linux
# check that vendor-reset is loaded
# sudo dmesg | grep vendor_reset


# Setup gpu.rom
sudo mkdir /usr/share/vgabios
sudo cp gpu.rom /usr/share/vgabios
sudo chmod -R 660 /usr/share/vgabios/gpu.rom
sudo chown raabe:raabe /usr/share/vgabios/gpu.rom

# <rom file="/usr/share/vgabios/gpu.rom"/>

# Start Virtual Network with every system start
# sudo virsh net-autostart default

# virtio driver windows 11
# https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md
