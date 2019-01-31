#!/bin/sh
## Usage: ATTR ARGS..      Build an attribute; ARGS passed to nix-instantiate

basename=$(basename $0)
nhroot="$(realpath $0 | xargs dirname)"

attr="$1"
test -n "$attr" || { echo "USAGE: ${basename} ATTR [COMPILER]" >&2; exit 1; }
shift

compiler=$(cat "${nhroot}/default-compiler.nix")

LOG="${nhroot}"/logs/"$attr".log
mkdir -p "${nhroot}"/logs/

NIX_ARGS="-A pkgs.haskell.packages."${compiler}"."${attr}" ${nhroot}/nixpkgs.nix"
NIX_DRV=$(nix-instantiate ${NIX_ARGS} "$@" 2>$LOG || true)
if ! test -n "$NIX_DRV"
then
        echo "### Instantiation failed:" >&2
        cat $LOG >&2
        echo "### Instantiation failed" >&2
        exit 1
fi

if ! nix-store --realise ${NIX_DRV} "$@"
then
        mkdir -p $(dirname ${LOG})
        echo "### Build failed:" >&2
        nix log $NIX_DRV > $LOG
        echo "### Build failed" >&2
        exit 1
fi
