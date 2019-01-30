#!/bin/sh

pkg=$1; shift
nhroot=$(dirname $0 | xargs realpath)

echo "Entering shell for: ${pkg}"
set -x
nix-shell "$@" -E "with (import ${nhroot}/nixpkgs.nix {}).haskell.packages.\"\${import ${nhroot}/default-compiler.nix}\"; shellFor { packages = p: [p.${pkg}]; withHoogle = true; }"
