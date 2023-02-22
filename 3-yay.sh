#!/bin/bash

# __   __ _ __   __
# \ \ / // \\ \ / /
#  \ V // _ \\ V / 
#   | |/ ___ \| |  
#   |_/_/   \_\_|  
#                 
# by Stephan Raabe (2023)
# ------------------------------------------------------
# Install Script for Yay
# ------------------------------------------------------
# Name: yay Install Script
# DESC: All required steps to install yay

echo "START YAY INSTALLATION..."
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
echo "DONE!"
