#!/bin/bash

programs="
    git,
    gcc,
    tree,
    python3,
    curl,
    tmux,
    exa,
    zsh
"

printRed() {
    printf "\033[31m$1\033[0m\n" 
}
printGreen() {
    printf "\033[32m$1\033[0m\n" 
}
printGrayBold() {
    printf "\033[1;38;5;245m$1\033[0m\n" 
}
printBlue() {
    printf "\033[34m$1\033[0m\n" 
}
printBlueBold() {
    printf "\033[1;34m$1\033[0m\n" 
}

# Function to check if a program is installed
checkInstalled() {
    command -v "$1" >/dev/null 2>&1
}

cat << "EOF"
   _         _                        _       
  /_\  _   _| |_ ___  _ __ ___   __ _| |_ ___ 
 //_\\| | | | __/ _ \| '_ ` _ \ / _` | __/ _ \
/  _  \ |_| | || (_) | | | | | | (_| | ||  __/
\_/ \_/\__,_|\__\___/|_| |_| |_|\__,_|\__\___|
-=============================================-                                              
EOF

# Update apt Package List
if checkInstalled "apt"; then
    sudo apt update
fi

printGreen "\n=====INSTALLING_APPLICATIONS====="

# function for installing neovim
installNvim() {
    if ! checkInstalled "nvim"; then
        printBlue "neovim is not installed, installing..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x ~/nvim.appimage
        mv -i ~/nvim.appimage /usr/bin/nvim
    else 
        printGreen "neovim is already installed"
    fi
}

#check which packageManager is installed
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
        printRed "Unsupported package manager"
    fi
}

# Split the comma-separated string manually
IFS=$'\n' read -r -d '' -a program_array < <(echo "$programs" | tr -d '[:space:]' | tr ',' '\n')

# Loop through the array of programs and install if not already installed
for program in "${program_array[@]}"; do
    if checkInstalled "$program"; then
        printGreen "$program is already installed"
    else
        printBlue "$program is not installed. Installing..."
        packageManager "$program"
    fi
done



#==========Other-Installs=============

# install Nvim
installNvim

# install Tmux plugin-manager
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    printGreen "TPM is already installed"
else 
    printBlue "TPM is not installed, installing..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install starship ZSH
if command -v starship >/dev/null 2>&1; then
    printGreen "starship is already installed"
else
    printBlue "starship is not installed, installing..."
    curl -sS https://starship.rs/install.sh | sh
fi

if command -v batcat >/dev/null 2>&1; then
    printGreen "bat is already installed"
else
    printBlue "bat is not installed, installing..."
    packageManager "bat"
fi

if command -v rg >/dev/null 2>&1; then
    printGreen "ripgrep is already installed"
else
    printBlue "ripgrep is not installed, installing..."
    packageManager "ripgrep"
fi

#=====================================



# Setup Dotfiles
printGreen "\n==========LINKING_FILES=========="
python3 .dotfilessetup.py

#printGreen "All programs are checked and installed if necessary"

printGrayBold "\n===========CHECK_SHELL==========="
# Check shell for zsh
if [ "$SHELL" = "$(which zsh)" ]; then
    printGrayBold "current Shell is zsh"
else 
    chsh -S $(which zsh)
    printBlueBold "set Shell to zsh"
fi

