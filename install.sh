#!/bin/bash

. /etc/os-release
OS=$ID_LIKE

if [[ "$OS" = "fedora" ]]; then
    sudo dnf upgrade
    sudo dnf install stow
    sudo dnf install zsh
elif [[ "$OS" = "debian" ]]; then
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
    sudo apt install stow
    sudo apt install zsh
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | zsh

# oh-my-zsh
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
chsh -s $(which zsh) # sets default shell to zsh
# NOTE: To set zsh on Fedora, use `sudo lchsh $USER`

# dotfiles

# Adopt all previous files
python3 generate.py
for dir in */ ; do
    # if the directory is not dotfiles, then adopt it
    if [ "$dir" != "dotfiles/" ] ; then
        echo "Adopting $dir"
        stow --adopt "$dir"
    fi
done

# Updated all dotfiles
python3 generate.py
for dir in */ ; do
    # if the directory is not dotfiles, then overwrite it
    if [ "$dir" != "dotfiles/" ] ; then
        echo "Stowing $dir"
        stow -R "$dir"
    fi
done
