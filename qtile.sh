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
pacman -S qtile picom starship chromium slock neomutt rofi pip neomutt nitrogen dunst ueberzug mpv freerdp spotifyd xfce4-power-manager chromium
echo "Main packages installed..."

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo "-> Install AUR packages"
yay -S pywal spotify-tui yaru-gtk-theme yaru-icon-theme
echo "AUR packages installed..."

# ------------------------------------------------------
# Install Pip packages
# ------------------------------------------------------
echo "-> Install Pip packages"
pip install openai
echo "Pip packages installed"

# ------------------------------------------------------
# Clone dotfiles
# ------------------------------------------------------
echo "-> Install dotfiles."
git clone https://gitlab.com/stephan-raabe/dotfiles.git /home/raabe/
echo "dotfiles clones into home directory"
chmod +x /home/raabe/dotfiles/gitpush.sh

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
echo "-> Create symbolic links"
mkdir /home/raabe/.config
ln -s /home/raabe/dotfiles/qtile/ ~/.config
ln -s /home/raabe/dotfiles/alacritty/ ~/.config
ln -s /home/raabe/dotfiles/neomutt/ ~/.config
ln -s /home/raabe/dotfiles/picom/ ~/.config
ln -s /home/raabe/dotfiles/ranger/ ~/.config
ln -s /home/raabe/dotfiles/rofi/ ~/.config
ln -s /home/raabe/dotfiles/spotifyd/ ~/.config
ln -s /home/raabe/dotfiles/vim/ ~/.config
rm /home/raabe/.bashrc
ln -s /home/raabe/dotfiles/.bashrc ~/.basrc
ln -s /home/raabe/dotfiles/vim/ ~/.config
echo "Symbolic links created..."

# ------------------------------------------------------
# Clone wallpapers
# ------------------------------------------------------
echo "-> Install wallpapers"
git clone https://gitlab.com/stephan-raabe/wallpaper.git /home/raabe/
echo "wallpapers cloned into home directory"

echo "Manual steps required:"
echo "Install Nerd fonts"
echo "Activate git config credential.helper store in repositories to disable credentials."
echo "DONE!"
