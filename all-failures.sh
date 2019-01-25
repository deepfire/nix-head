#!/bin/sh

nix-shell --cores 0 -j4 --no-build-output --keep-going --keep-failed
