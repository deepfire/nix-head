#!/bin/sh
## Usage: NIXSHELL_ARGS..  Build as many dependencies for \$CWD/shell.nix,\n\t\t\t\t\t  as possible

NIX_BUILD_FLAGS=${NIX_BUILD_FLAGS:---cores 0 -j4 --no-build-output}

nix-shell --cores 0 -j4 --no-build-output --keep-going --arg trace true "$@"
