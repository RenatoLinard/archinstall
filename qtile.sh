#!/bin/bash

# ------------------------------------------------------
# Install Script for Qtile
# IMPORTANT: chmod +x qtile.sh
# yay must be installed
# Copy this script into the home directory and start.
# ------------------------------------------------------

read -p "Do you want to start? " s
echo "START QTILE INSTALLATION..."

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo "-> Install main packages"
pacman -S xorg xorg-xinit qtile alacritty picom starship chromium slock neomutt rofi pip neomutt dunst ueberzug mpv freerdp spotifyd xfce4-power-manager python-pip chromium thunar lxappearance papirus-icon-theme ttf-font-awesome ttf-fira-code ttf-firacode-nerd
echo "Main packages installed..."

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo "-> Install AUR packages"
yay -S pywal 
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
ln -s /home/$(whoami)/dotfiles/.bashrc ~/.bashrc
rm /home/$(whoami)/.xinitrc
ln -s /home/$(whoami)/dotfiles/.xinitrc ~/.xinitrc
ln -s /home/$(whoami)/dotfiles/starship/starship.toml ~/.config/starship.toml
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

# ------------------------------------------------------
# Install startship plain text 
# ------------------------------------------------------
starship preset plain-text-symbols > ~/.config/starship.toml


echo "Manual steps required:"
echo "Activate git config credential.helper store in repositories to disable credentials."
echo "DONE!"
