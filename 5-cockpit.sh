#!/bin/bash

#   ____           _          _ _   
#  / ___|___   ___| | ___ __ (_) |_ 
# | |   / _ \ / __| |/ / '_ \| | __|
# | |__| (_) | (__|   <| |_) | | |_ 
#  \____\___/ \___|_|\_\ .__/|_|\__|
#                      |_|          
#
# by Stephan Raabe (2023)                            
# -----------------------------------------------------
# Cockpit Install Script
# -----------------------------------------------------
# NAME: Cockpit Install Script
# DESC: Installation script the web based system manager cockpit
# WARNING: Run this script at your own risk.

# -----------------------------------------------------
# Confirm Start
# -----------------------------------------------------
read -p "Do you want to start now?" c

# -----------------------------------------------------
# Install zram
# -----------------------------------------------------
sudo pacman -S cockpit packagekit

# -----------------------------------------------------
# Enable socket
# -----------------------------------------------------
sudo systemctl enable --now cockpit.socket

echo "DONE! Open http://localhost:9090 in your browser."
