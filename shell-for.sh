#!/bin/sh

pkg=${1:-$(basename $(pwd))}
case $1 in
        --* | "") true;;
        *) shift;;
esac
nhroot=$(realpath $0 | xargs dirname)

echo "Entering shell for: ${pkg}"
set -x
nix-shell "$@" -E "with (import ${nhroot}/nixpkgs.nix {}).haskell.packages.\"\${import ${nhroot}/default-compiler.nix}\"; shellFor { packages = p: [p.${pkg}]; withHoogle = true; }"
