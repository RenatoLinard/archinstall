#!/bin/bash

# ------------------------------------------------------
# Install Script for Qtile
# IMPORTANT: chmod +x qtile.sh
# yay must be installed
# ------------------------------------------------------

read -p "Do you want to start? " s
echo "START QTILE INSTALLATION..."

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo "-> Install main packages"
pacman -S xorg xorg-xinit qtile alacritty picom starship chromium slock neomutt rofi pip neomutt nitrogen dunst ueberzug mpv freerdp spotifyd xfce4-power-manager python-pip chromium
echo "Main packages installed..."

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo "-> Install AUR packages"
yay -S pywal nerd-fonts-complete-starship 
echo "AUR packages installed..."

# ------------------------------------------------------
# Install Pip packages
# ------------------------------------------------------
echo "-> Install Pip packages"
pip install openai psutil
echo "Pip packages installed"

# ------------------------------------------------------
# Clone dotfiles
# ------------------------------------------------------
echo "-> Install dotfiles."
git clone https://gitlab.com/stephan-raabe/dotfiles.git /home/$(whoami)/
echo "dotfiles clones into home directory"
chmod +x /home/$(whoami)/dotfiles/gitpush.sh

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo "-> Create symbolic links"
mkdir /home/$(whoami)/.config
ln -s /home/$(whoami)/dotfiles/qtile/ ~/.config
ln -s /home/$(whoami)/dotfiles/alacritty/ ~/.config
ln -s /home/$(whoami)/dotfiles/neomutt/ ~/.config
ln -s /home/$(whoami)/dotfiles/picom/ ~/.config
ln -s /home/$(whoami)/dotfiles/ranger/ ~/.config
ln -s /home/$(whoami)/dotfiles/rofi/ ~/.config
ln -s /home/$(whoami)/dotfiles/spotifyd/ ~/.config
ln -s /home/$(whoami)/dotfiles/vim/ ~/.config
rm /home/($whoami)/.bashrc
ln -s /home/$(whoami)/dotfiles/.bashrc ~/.basrc
echo "Symbolic links created..."

# ------------------------------------------------------
# Clone wallpapers
# ------------------------------------------------------
echo "-> Install wallpapers"
git clone https://gitlab.com/stephan-raabe/wallpaper.git /home/$(whoami)/
echo "wallpapers cloned into home directory"

# ------------------------------------------------------
# Init pywal
# ------------------------------------------------------
wal -i ~/wallpaper/default.jpg

echo "Manual steps required:"
echo "Install Nerd fonts"
echo "Activate git config credential.helper store in repositories to disable credentials."
echo "DONE!"
