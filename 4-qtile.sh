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
sudo pacman -S qtile alacritty nitrogen picom starship chromium slock neomutt rofi dunst ueberzug mpv freerdp spotifyd xfce4-power-manager python-pip thunar lxappearance papirus-icon-theme ttf-font-awesome gvfs exa bat ttf-fira-sans ttf-fira-code ttf-firacode-nerd

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo "-> Install AUR packages"
yay -S pywal timeshift adwaita-dark 

# ------------------------------------------------------
# Install Pip packages
# ------------------------------------------------------
echo "-> Install Pip packages"
pip install psutil

# ------------------------------------------------------
# Clone dotfiles
# ------------------------------------------------------
echo "-> Install dotfiles."
git clone https://gitlab.com/stephan-raabe/dotfiles.git ~/dotfiles

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo "-> Create symbolic links"
mkdir ~/.config
ln -s ~/dotfiles/qtile/ ~/.config
ln -s ~/dotfiles/alacritty/ ~/.config
ln -s ~/dotfiles/neomutt/ ~/.config
ln -s ~/dotfiles/picom/ ~/.config
ln -s ~/dotfiles/ranger/ ~/.config
ln -s ~/dotfiles/rofi/ ~/.config
ln -s ~/dotfiles/spotifyd/ ~/.config
ln -s ~/dotfiles/vim/ ~/.config
rm ~/.bashrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
rm ~/.xinitrc
ln -s ~/dotfiles/.xinitrc ~/.xinitrc
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship.toml

# ------------------------------------------------------
# Clone wallpapers
# ------------------------------------------------------
echo "-> Install wallpapers"
git clone https://gitlab.com/stephan-raabe/wallpaper.git ~/wallpaper

# ------------------------------------------------------
# Init pywal
# ------------------------------------------------------
wal -i ~/wallpaper/default.jpg

# ------------------------------------------------------
# Install startship plain text 
# ------------------------------------------------------
starship preset plain-text-symbols > ~/.config/starship.toml

sleep 3

echo "Manual steps required:"
echo "Activate git config credential.helper store in repositories to disable credentials."
echo "DONE!"
