#!/bin/bash

# is_wsl=$1

# sudo apt install stow

# stow bash

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
dot git
