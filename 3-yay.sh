#!/bin/bash

# ------------------------------------------------------
# Install Script for Yay
# IMPORTANT: chmod +x yay.sh
# ------------------------------------------------------

echo "START YAY INSTALLATION..."

git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
echo "DONE!"
