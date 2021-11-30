#!/bin/bash

# https://gitlab.com/risingprismtv/single-gpu-passthrough/-/wikis/1)-Preparations
# Set the parameter intel_iommu=on or amd_iommu=on respective to your system in the grub config
# Set the parameter iommu=pt in grub config for safety reasons
# You can add this parameter video=efifb:off fixes issues that few people have with returning back to the host. (Mostly AMD users)

sudo vim /etc/default/grub

printf "uncommend the the follow lines: # unix_sock_group = libvirt and # unix_sock_rw_perms = 0770"
sudo vim /etc/libvirt/libvirtd.conf

printf "edit the following lines user = 'raabe' and group = 'raabe'"
sudo vim /etc/libvirt/qemu.conf

sudo systemctl restart libvirtd

# Setup gpu.rom
sudo mkdir /usr/share/vgabios
sudo cp gpu.rom /usr/share/vgabios
sudo chmod -R 660 /usr/share/vgabios/gpu.rom
sudo chown raabe:raabe /usr/share/vgabios/gpu.rom

# <rom file="/usr/share/vgabios/gpu.rom"/>
