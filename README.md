# dotfiles

This repository contains dotfiles for WSL and Linux. `install.sh` generates dotfiles for either WSL or Linux, and uses symlinks to install them.

**WARNING:** `install.sh` will overwrite existing dotfiles.

## Prerequisites

- `git`
- `apt`
- Python 3.6+

`install.sh` requires root permissions.

## Installation

``` shell
cd ~
git clone git@github.com:dalyIsaac/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

## How it works

- `.gitignore` forces git to ignore everything, apart from the few files it explicitly includes.
- All the dotfiles are stored in `./dotfiles`.
  - Dotfiles contain configurations for both WSL and Linux.
  - Lines at the very start are generic, and are used by both WSL and native Linux.
  - Lines which include `env:wsl` indicate that the following lines are WSL specific.
  - Lines which include `env:linux` indicate that the following lines are specific to native Linux.
- `install.sh` installs `stow`, which is used to create symlinks from the `dotfiles` repo to `$HOME`.
  - Additionally, it uses `./generate.py` to generate dotfiles which are specific to the current environment (WSL vs. native Linux) - for example, if in WSL, all the generic lines and WSL lines are emitted into a dotfile, and Linux lines are ignored.
  - The generated dotfiles are stored at the root of the project - for example, `./dotfiles/bash/.bashrc` → `./bash/.bashrc` (these generated dotfiles are ignored by `git`).
  - `install.sh` then uses stow to symlink the dotfiles.
  - `zsh`, [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh), and various `zsh` extensions are installed.
  - `zsh` is set as the default terminal.

### Variables

String interpolation occurs using the syntax `{var:variable_name}`. For example, `{var:username}` becomes `dalyisaac`. Variables are stored in the `VARS` dictionary in `generate.py`. If a variable is not in the dictionary, then the string interpolation is ignored - i.e. `{var:not_a_username}` remains the same. 
