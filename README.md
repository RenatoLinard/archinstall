# Arch Install Script with btrfs for Timeshift or snapper

This is a bash based Arch Linux installation script with EFI boot loader and btrfs partition prepared for Timeshift or snapper.

## Getting started

To make it easy for you to get started, here's a list of recommended next steps.

```
# Load keyboard layout
loadkeys de
loadkeys de-latin1

# Connect to WLAN (if not LAN)
iwctl --passphrase [password] station wlan0 connect [network]

# Check internet connection
ping -c4 www.google.de

# Check partitions
lsblk

# Create partitions
gdisk /dev/sda
# Partition 1: +512M ef00 (for EFI)
# Partition 2: Available space 8300 (for Linux filesystem)
# Write w, Confirm Y

# Sync package

pacman -Syy

# Install git
pacman -S git

# Clone Installation
git clone https://gitlab.com/stephan-raabe/archinstall.git
cd archinstall

# Start the script
./1-install.sh

```

