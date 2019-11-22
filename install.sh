#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo apt install stow

python3 generate.py

update() {
    local dir=$1
    stow -R "$dir"
}

exclude=("dotfiles" ".vscode")

for dir in */ ; do
    # if the directory is not excluded, then update it
    if [[ ! "${exclude[@]}" =~ "${dir}" ]] ; then
        update "$dir"
    fi
done

# zsh
sudo apt install zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
chsh -s $(which zsh) # sets default shell to zsh
