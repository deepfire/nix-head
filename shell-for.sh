#!/bin/sh

cwdAttr="$(basename $(pwd))"
attr=${1:-${cwdAttr}}
case $1 in
        --* | "") true;;
        *) shift;;
esac
nhroot="$(realpath $0 | xargs dirname)"

echo "Entering shell for: ${attr}"
set -x
nix-shell "$@" -E "with (import ${nhroot}/nixpkgs.nix {}).haskell.packages.\"\${import ${nhroot}/default-compiler.nix}\"; shellFor { packages = p: [p.${attr}]; withHoogle = true; }"
