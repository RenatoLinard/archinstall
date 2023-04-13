#!/bin/bash
#  _____ _                     _     _  __ _    
# |_   _(_)_ __ ___   ___  ___| |__ (_)/ _| |_  
#   | | | | '_ ` _ \ / _ \/ __| '_ \| | |_| __| 
#   | | | | | | | | |  __/\__ \ | | | |  _| |_  
#   |_| |_|_| |_| |_|\___||___/_| |_|_|_|  \__| 
#                                               
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 
# Timeshift Install Script
# yay must be installed
# -----------------------------------------------------
# NAME: Timeshift Installation
# DESC: Installation script for timeshift
# WARNING: Run this script at your own risk.

# -----------------------------------------------------
# Confirm Start
# -----------------------------------------------------
read -p "Do you want to start now?" c

# -----------------------------------------------------
# Install zram
# -----------------------------------------------------
yay --noconfirm -S timeshift

