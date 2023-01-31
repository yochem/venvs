# venvs - wrapper for Python's venv

This script gathers all venvs in one folder and gives system-wide access to them.


**Warning**: It is kinda hacky. Do not trust it without reading through the
code (it's not that long).

## Installation

Download this repository somewhere on your system. Then put this somewhere in
your .bashrc / config.fish:

```
# for bash:
[ -f "path/to/venvs.bash" ] && source "path/to/venvs.bash"

# for zsh (it's just a link to venvs.bash):
[ -f "path/to/venvs.zsh" ] && source "path/to/venvs.zsh"

# for fish
[ -f "path/to/venvs.fish" ] && source "path/to/venvs.fish"
```

## Venvs locations
The virtual environments are created in $XDG_DATA_HOME/venvs. This usually
means ~/.local/share/venvs.

To place it somewhere else, set $XDG_DATA_HOME to another value. After that,
`mv` the contents to the new directory.

```
Usage:
venvs <venv>                 activate venv in the *global venvs directory*
venvs new <venv> <options>   create new venv in *global venvs directory*
                             note: run python3 -m venv --help to see options

venvs                        activate venv in *current directory*
venvs new ./<venv> <options> create new venv in *current directory*
                             note: run python3 -m venv --help to see options

venvs [ls | list]            list all venvs
venvs [rm | remove] <venv>   remove a venv
venvs deactivate             deactivate current venv
venvs [-h | --help]          show this help
```
