#!/bin/bash
#  ____           _                 _  
# |  _ \ _ __ ___| | ___   __ _  __| | 
# | |_) | '__/ _ \ |/ _ \ / _` |/ _` | 
# |  __/| | |  __/ | (_) | (_| | (_| | 
# |_|   |_|  \___|_|\___/ \__,_|\__,_| 
#                                      
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 
# Preload Install Script
# yay must be installed
# -----------------------------------------------------
# NAME: Preload Installation
# DESC: Installation script for preload
# WARNING: Run this script at your own risk.

# -----------------------------------------------------
# Confirm Start
# -----------------------------------------------------
read -p "Do you want to start now?" c

# -----------------------------------------------------
# Install zram
# -----------------------------------------------------
yay --noconfirm -S preload

