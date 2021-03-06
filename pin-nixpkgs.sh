#!/bin/sh
## Usage: REV [GHUSER]     Set Nixpkgs commit from a specifid Github user (NixOS)

rev=$1
upstream=${2:-NixOS}

case ${upstream} in
     local | home ) rbase=file://$HOME; upstream='';;
     * )            rbase=https://github.com/ ;;
esac
nix-prefetch-git --no-deepClone $rbase${upstream}/nixpkgs ${rev} > $(dirname $0)/pins/nixpkgs.src-json
