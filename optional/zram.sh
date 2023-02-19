#!/bin/bash

# -----------------------------------------------------
# ZRAM Install Script
# yay must be installed
# -----------------------------------------------------

read -p "Do you want to start now?" c

# Install zram
yay -S zram-generator

# Edit zram-generator.conf
echo "Manual step required!"
echo "Add to /etc/systemd/zram-generator.conf (new file)" 
echo "[zram0]"
echo "zram-size = ram / 2"

# Open zram-generator.conf
read -p "Open zram-generator.conf now? " c
sudo vim /etc/systemd/zram-generator.conf

# Restart services
read -p "Start systemctl services now? " c
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

echo "DONE! Reboot now and check with free -h the ZRAM installation."
