#!/bin/bash

. /etc/os-release
OS=$ID_LIKE

echo "Setting up dotfiles for $OS"
echo "Installing dependencies..."

if [[ "$OS" = "fedora" ]]; then
    if [ -z "$REMOTE_CONTAINERS_IPC" ]; then
        sudo dnf upgrade
    fi

    sudo dnf install stow
    sudo dnf install zsh
    sudo dnf install cloc
    sudo dnf install fzf
elif [[ "$OS" = "debian" ]]; then
    if [ -z "$REMOTE_CONTAINERS_IPC" ]; then
        sudo apt-get update
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
    fi

    sudo apt install stow
    sudo apt install zsh
    sudo apt install cloc
    sudo apt install fzf
fi

echo "Dependencies installed"

echo "Installing starship..."
curl -fsSL https://starship.rs/install.sh | zsh

echo "Installing oh-my-zsh..."
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ZSH_PLUGIN=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions          $ZSH_PLUGIN/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git  $ZSH_PLUGIN/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab                         $ZSH_PLUGIN/fzf-tab
git clone https://github.com/zdharma/fast-syntax-highlighting.git   $ZSH_PLUGIN/fast-syntax-highlighting

echo "Configuring default shell..."
if [ "$0" != $(which zsh) ]; then
    if [ "$OS" = "debian" ]; then
        chsh -s $(which zsh) # sets default shell to zsh
    elif [ "$OS" = "fedora" ]; then
        sudo lchsh $USER
    fi
fi

echo "Adopting dotfiles..."

# Adopt all previous files
python3 generate.py
for dir in */ ; do
    # if the directory is not dotfiles or starship, then adopt it
    if [ "$dir" != "dotfiles/" ] && [ "$dir" != "starship/" ] ; then
        echo "Adopting $dir"
        stow --adopt "$dir"
    fi
done

# Updated all dotfiles
python3 generate.py
for dir in */ ; do
    # if the directory is not dotfiles or starship, then overwrite it
    if [ "$dir" != "dotfiles/" ] && [ "$dir" != "starship/" ] ; then
        echo "Stowing $dir"
        stow -R "$dir"
    fi
done

# Replace xdg-open with wslview
if grep -q WSL2 /proc/version; then
    sudo ln -s $(which wslview) /usr/local/bin/xdg-open
fi
