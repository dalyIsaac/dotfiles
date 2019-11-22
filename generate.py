#!/usr/bin/python3

import os
import pathlib
from enum import Enum
from platform import release


DIR = "dotfiles"
WSL = "env:wsl"
LINUX = "env:linux"


class Section(Enum):
    WSL = 1
    Linux = 2


def get_section(line: str):
    """
    Indicates if the current line indicates a specific section.

    `env:wsl` in a string indicates that the following lines should only be 
    placed in files if the environment is WSL.

    `env:linux` in a string indicates that the following lines should only be 
    placed in files if the environment is native Linux.
    """
    arr = line.strip().lower().split()
    if WSL in arr:
        return Section.WSL
    elif LINUX in arr:
        return Section.Linux
    else:
        return None


def generate(in_filename: str, out_filename: str):
    """Generates the correct file based on the current environment."""
    is_wsl = True if "microsoft" in release().lower() else False
    section = None
    with open(in_filename) as in_file, open(out_filename, "w") as out_file:
        for line in in_file:
            new_section = get_section(line)
            if new_section is not None and new_section != section:
                section = new_section
            if (
                section is None
                or (is_wsl and section == Section.WSL)
                or (not is_wsl and section == Section.Linux)
            ):
                out_file.write(line)


def main():
    """
    Takes all of the files in `dotfiles`, generates the correct file based on
    the current environment (WSL vs native Linux), and places it into the root
    of the project.
    """
    for root, _dirs, files in os.walk(DIR):
        for file in files:
            try:
                in_file = f"{root}/{file}"
                out_dir = os.path.join(os.pardir, root)
                pathlib.Path(out_dir).mkdir(parents=True, exist_ok=True)
                generate(in_file, f"{out_dir}/{file}")
            except ValueError:
                pass


if __name__ == "__main__":
    main()
