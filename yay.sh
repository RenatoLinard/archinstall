#!/bin/bash

# ------------------------------------------------------
# Install Script for Yay
# IMPORTANT: chmod +x yay.sh
# ------------------------------------------------------

echo "START YAY INSTALLATION..."

sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R raabe:raabe ./yay-git

echo "The following manual steps are required:"
echo "cd yay-git/"
echo "makepkg -si"

echo "DONE!"
