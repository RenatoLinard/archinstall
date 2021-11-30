#!/bin/bash

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