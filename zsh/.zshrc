# Autostart Tmux
if [ "$TMUX" = "" ]; then tmux; fi

# Set Path Correctly
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program  

# Path to plugins
ZSH_PLUGINS="$HOME/.zsh/plugins"

# Ensure the plugins directory exists
mkdir -p $ZSH_PLUGINS

# zsh-syntax-highlighting
if [ ! -d $ZSH_PLUGINS/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting
fi
source $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions
if [ ! -d $ZSH_PLUGINS/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_PLUGINS/zsh-autosuggestions
fi
source $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh


# History Settings
HISTFILE=~/.zsh_history 
HISTSIZE=1000000
SAVEHIST=1000000

setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS

# Set list-colors to enable filename colorizing
zstyle ':completion*' list-colors ${(s.:.)LS_COLORS}

#===========Aliases============

# LS ALIASES
#alias ls="ls --color=auto"
#alias lsa="ls -a --color=auto"

# TREE ALIASES
alias tree="tree -C"
alias tr="tree -C"
alias tra="tree -a -C"

# BAT ALIASES
alias bat="batcat"

# EXA ALIASES
alias ls="exa"
alias lsa="exa -a"
alias ils="exa --icons"
alias ilsa="exa --icons -a"

# Keybinds
bindkey '\e[Z' autosuggest-accept #{"command": {"action:sendInput", "input": \u001b[Z}, "keys": "shift+tab"}

# Enable starship (Last load)
eval "$(starship init zsh)"
