cd ..
rm -rf .zcompdump .zcompdump* .zsh_history .oh-my-zsh
cd dotfiles

for dir in */ ; do
    # if the directory is not dotfiles, then unstow it
    if [ "$dir" != "dotfiles/" ] ; then
        echo "Unstowing $dir"
        stow -D "$dir"
    fi
done

sudo apt-get remove zsh
rm -rf "$NVM_DIR"
