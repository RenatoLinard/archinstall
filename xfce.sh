#!/bin/bash

sudo pacman -S xfce4 xfce4-goodies chromium arc-gtk-theme arc-icon-theme

/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
sudo reboot
