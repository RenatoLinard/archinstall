# Pre Install

## Load keyboard layout (replace de with us, fr, es if needed)
loadkeys br-abnt

## Increase font size (optional)
setfont ter-p20b

## Conexão Wi-Fi com os seguintes comandos:

```shell
iwctl
device list
adapter [nome_do_adaptador] set-property Powered on
station wlan0 show
station wlan0 scan
station wlan0 connect [nome_da_rede]
```

## Check internet connection
ping -c4 www.archlinux.org

## Check partitions
lsblk

## Create partitions
 If the disk from which you want to boot already has an EFI system partition, do not create another one, but use the existing partition instead.

 - gdisk /dev/sda
 - Partition 1: +512M ef00 (for EFI)
 - Partition 2: Available space 8300 (for Linux filesystem)
 - (Optional Partition 3 for Virtual Machines)
 - Write w, Confirm Y

## Sync package
pacman -Syy

## Maybe it's required to install the current archlinux keyring
 if the installation of git fails.
pacman -S archlinux-keyring
pacman -Syy

## Install git
pacman -S git

## Clone Installation
git clone https://github.com/RenatoLinard/archinstall.git
cd archinstall

## Start the script
./1-install.sh

