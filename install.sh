#!/bin/bash

# DOTFILES

sudo apt install stow

is_wsl=""
if [[ $(grep microsoft /proc/version) ]]; then
    is_wsl="wsl"
fi

# `dot` is used if there's a difference between wsl and Linux dotfiles
dot() {
    local dir=$1
    stow "$is_wsl""$dir"
}

stow bash
stow zsh
dot git

# zsh
sudo apt install zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
chsh -s $(which zsh) # sets default shell to zsh
