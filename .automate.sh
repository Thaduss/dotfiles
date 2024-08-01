#!/bin/bash

# Define a comma-separated list of programs
programs="
    git,
    gcc,
    tree,
    bat,
    python3,
    ripgrep,
    tmux,
    zsh
"







# Function to check if a program is installed
checkInstalled() {
    command -v "$1" >/dev/null 2>&1
}

packageManager() {
    if checkInstalled "apt"; then
        sudo apt install -y "$1"
    elif checkInstalled "dnf"; then
        sudo dnf install -y "$1"
    elif checkInstalled "pacman"; then
        sudo pacman -Sy --noconfirm "$1"
    elif checkInstalled "zypper"; then
        sudo zypper install -y "$1"
    else 
        echo "Unsupported package manager. Please install git, stow, zsh, tmux, and neovim manually."
    fi
}
# Update package list
#sudo apt update

# Split the comma-separated string manually
IFS=$'\n' read -r -d '' -a program_array < <(echo "$programs" | tr -d '[:space:]' | tr ',' '\n')

# Loop through the array of programs and install if not already installed
for program in "${program_array[@]}"; do
    if checkInstalled "$program"; then
        echo "$program is already installed."
    else
        echo "$program is not installed. Installing..."
        packageManager "$program"
    fi
done

# Setup Dotfiles
python3 .dotfilessetup.py

echo "All programs are checked and installed if necessary."

#chsh -S $(which zsh)
