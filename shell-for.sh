#!/bin/sh
## Usage: [ATTR] ARGS..    'nix-shell' for the specified attribute (from $PWD),\n\t\t\t\t\t  with any ARGS passed to nix-shell

cwdAttr="$(basename $(pwd))"
attr=${1:-${cwdAttr}}
case $1 in
        --* | "") true;;
        *) shift;;
esac
nhroot="$(realpath $0 | xargs dirname)"

echo "Entering shell for: ${attr}"
set -x

nix-shell "$@" -j4 --cores 0 -E \
"{ compiler ? import ${nhroot}/default-compiler.nix, extra ? null, extras ? [\"ghcid\"] }:
let ghc = (import ${nhroot}/nixpkgs.nix {}).haskell.packages.\"\${compiler}\";
in with ghc;
  shellFor {
    packages = p: [p.${attr}];
    withHoogle = true;
    buildInputs = map (name: ghc.\"\${name}\") ((if extra != null then [extra] else []) ++ extras);
  }"
