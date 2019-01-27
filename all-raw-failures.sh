#!/bin/sh

NIX_BUILD_FLAGS=${NIX_BUILD_FLAGS:---cores 0 -j4 --no-build-output}

nix-shell --cores 0 -j4 --no-build-output --keep-going --keep-failed --arg trace true
