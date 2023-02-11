#!/bin/bash

# ------------------------------------------------------
# Install Script for Yay
# IMPORTANT: chmod +x yay.sh
# ------------------------------------------------------

echo "START YAY INSTALLATION..."

sudo git clone https://aur.archlinux.org/yay-git.git /opt
sudo chown -R raabe:raabe /opt/yay-git

echo "The following manual steps are required:"
echo "cd /opt/yay-git"
echo "makepkg -si"

echo "DONE!"
