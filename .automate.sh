#!/bin/bash

programs="
    git,
    gcc,
    tree,
    python3,
    curl,
    tmux,
    exa,
    btop,
    npm,
    neofetch,
    zathura,
    xdotool,   
    biber,
    latexmk,   
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
elif checkInstalled "dnf"; then
    sudo dnf check-update
elif checkInstalled "pacman"; then
    sudo pacman -Sy
elif checkInstalled "zypper"; then
    sudo zypper refresh
fi

printGreen "\n=====INSTALLING_APPLICATIONS====="

# function for installing neovim
installNvim() {
    # Check for old nvim version 
    if checkInstalled "nvim"; then
        targetVersion="0.10.0"
        # Get the Neovim version with awk
        NVIM_VERSION=$(nvim --version | head -n 1 | awk '{print $2}')
        # Remove 'v' from 'v x.x.x'
        if [[ "$NVIM_VERSION" == v* ]]; then
        NVIM_VERSION=${NVIM_VERSION:1}
        fi
        if [[ $(echo -e "$NVIM_VERSION\n$targetVersion" | sort -V | tail -n1) == "$targetVersion" ]]; then
        echo "Neovim version is $NVIM_VERSION. Removing Neovim..."
        packageManagerRemove "neovim"
        fi
    fi

    if ! checkInstalled "nvim"; then
        printBlue "neovim is not installed, installing..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x ~/dotfiles/nvim.appimage
        sudo mv -i ~/dotfiles/nvim.appimage /usr/bin/nvim
    else 
        printGreen "neovim v$NVIM_VERSION is already installed"
    fi
}

# Installing gcm only needed for wsl
InstallGcm() {
    if command -v git-credential-manager >/dev/null 2>&1; then
        printGreen "gcm is already installed"
    else
        printBlue "gcm is not installed, installing..."
        curl -L -o gcm-linux_amd64.deb https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.5.1/gcm-linux_amd64.2.5.1.deb
        sudo dpkg -i ~/dotfiles/gcm-linux_amd64.deb
        git-credential-manager configure
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
    # Check if installed succesfully
    if checkInstalled "$1"; then
        printGreen "$1 has been installed succesfully"
    else
        printRed "err: $1 could not be installed"
    fi

}

packageManagerRemove() {
    if checkInstalled "apt"; then
        sudo apt remove -y "$1"
    elif checkInstalled "dnf"; then
        sudo dnf remove -y "$1"
    elif checkInstalled "pacman"; then
        sudo pacman -R --noconfirm "$1"
    elif checkInstalled "zypper"; then
        sudo zypper remove -y "$1"
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
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# Install bat which is under the name 'batcat'
if command -v batcat >/dev/null 2>&1; then
    printGreen "bat is already installed"
else
    printBlue "bat is not installed, installing..."
    packageManager "bat"
fi

# Install ripgrep
if command -v rg >/dev/null 2>&1; then
    printGreen "ripgrep is already installed"
else
    printBlue "ripgrep is not installed, installing..."
    packageManager "ripgrep"
fi

# Install git credential manager (uncomment when using wsl)
# InstallGcm
    
#=====================================

# Setup Dotfiles
printGreen "\n==========LINKING_FILES=========="
python3 .dotfileslinks.py

# Sourcing tmux for plugin installation
printGreen "\n=====INSTALLING_TMUX_PLUGINS====="
~/.tmux/plugins/tpm/scripts/install_plugins.sh

#=====================================

printGrayBold "\n===========CHECK_SHELL==========="
# Check shell for zsh
if [ "$SHELL" = "$(which zsh)" ]; then
    printGrayBold "current Shell is 'zsh'"
else 
    chsh -s $(which zsh)
    printBlueBold "set default Shell to 'zsh'"
    if ! tmux ls &> /dev/null; then 
    tmux
    fi
    exec $(which zsh)
fi

