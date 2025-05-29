#!/bin/bash

set -e

# Check if the script is being run with sudo
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run with sudo."
  exit 1
fi

## Set up parallel downloads pacman.conf
config_file="/etc/pacman.conf"

# Check if ParallelDownloads already exists
if grep -q "^ParallelDownloads =" "$config_file"; then
  # Comment out existing ParallelDownloads line
  sed -i '/^ParallelDownloads = /s/^/#/' "$config_file"
else
  echo "ParallelDownloads = 20" >>"$config_file"
fi

echo "Pacman configuration updated successfully."

# set up parallel compilation
njobs=$(nproc)
export MAKEFLAGS="-j$njobs"
echo "makepkg temporary configuration done"

# Update system
echo "Updating system"
sudo pacman -Syuu --noconfirm

echo "Before continuing make a reboot and run the script again to make sure the system is up to date"
echo "To exit the script press Ctrl+C, if reboot already done wait 5 seconds"
sleep 5

# Git installation
echo "Installing git"
sudo pacman -S git --noconfirm

# Installation of paru AUR helper
echo "Installing paru"
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

## ------------------------------ Essential packages ----------------------------------- ##
# Installation of brave
echo "Installing brave"
paru -S brave-bin --noconfirm

# Installation of foot terminal
echo "Installing foot terminal emulator"
sudo pacman -S foot --noconfirm

# Installing Neovim
echo "Installing neovim"
sudo pacman -S neovim --noconfirm

# Installation of zfz
echo "Installing zfz"
sudo pacman -S zfz --noconfirm

# Installation pipx
echo "Installing pipx"
sudo pacman -S python-pipx --noconfirm

## ------------------------------ Good to have packages ----------------------------------- ##
# Cat clone with wings
echo "Installing bat"
sudo pacman -S bat --noconfirm

# Render markdown in terminal
echo "Installing glow"
sudo pacman -S glow --noconfirm

# Fuzzy finder
echo "Installing fzf"
sudo pacman -S fzf --noconfirm

# TUI - bluetooth manager
echo "Installing blueTUIth"
paru -S bluetuith --noconfirm

# ls on steroids
echo "Installing eza"
sudo pacman -S exa --noconfirm

# Disk usage analyzer
echo "Installing duf"
sudo pacman -S duf --noconfirm

# Monitor system resources
echo "Installing Btop++"
sudo pacman -S bpytop --noconfirm

# Upgrade system utilities
echo "Installing topgrade"
paru -S topgrade --noconfirm

# System information
echo "Installing neofetch"
sudo pacman -S neofetch --noconfirm

# Auto-mount USB drives
echo "Installing udiskie"
sudo pacman -S udiskie --noconfirm

# Clipboard manager
echo "Installing cliphist"
sudo pacman -S cliphist --noconfirm

# Screen brightness control
echo "Installing brightnessctl"
sudo pacman -S brightnessctl --noconfirm

# Trash manager
echo "Installing trashy"
paru -S trashy --noconfirm

# Screen temperature control
echo "Installing wl-gammarelay-rs"
paru -S wl-gammarelay-rs --noconfirm

# font
echo "Installing ttf-jetbrains-mono-nerd"
sudo pacman -S ttf-jetbrains-mono-nerd --noconfirm

## ------------------------------ Applications ----------------------------------- ##
echo "Installing Visual Studio Code"
paru -S visual-studio-code-bin --noconfirm

echo "Installing KeePassXC"
sudo pacman -S keepassxc --noconfirm

# To trasnfer files between devices
echo "Installing LocalSend"
paru -S localsend --noconfirm

# Note taking app
echo "Installing Obsidian"
sudo pacman -S obsidian --noconfirm

# OneDrive sync
echo "Installing OneDriver"
paru -S onedriver --noconfirm

# File manager
echo "Installing Nemo"
sudo pacman -S nemo --noconfirm

## ------------------------------ Fruibility and appearance ----------------------------------- ##
# Installation of waybar - upper bar
echo "Installing waybar"
sudo pacman -S waybar --noconfirm

# Swaylock-effects for lockscreen
echo "Installing swaylock-effects"
paru -S swaylock-effects-git --noconfirm

# Notification daemon
echo "Installing mako"
paru -S mako --noconfirm

# For screen capture
echo "Installing grim"
sudo pacman -S grim --noconfirm

echo "Installing slurp"
sudo pacman -S slurp --noconfirm

# App Launcher
echo "Installing Rofi"
sudo pacman -S rofi --noconfirm
