#!/bin/sh

attr="$1"
test -n "$attr" || { echo "USAGE: $(basename $0) ATTR [COMPILER]" >&2; exit 1; }

compiler=${2:-$(cat ./default-compiler.nix)}

LOG=logs/"$attr".log

NIX_ARGS="-A pkgs.haskell.packages."${compiler}"."$attr" ./nixpkgs.nix"
NIX_DRV=$(nix-instantiate ${NIX_ARGS} 2>$LOG || true)
if ! test -n "$NIX_DRV"
then
        echo "### Instantiation failed:" >&2
        cat $LOG >&2
        echo "### Instantiation failed" >&2
        exit 1
fi

if ! nix-store --realise ${NIX_DRV}
then
        mkdir -p logs
        echo "### Build failed:" >&2
        nix log $NIX_DRV > $LOG
        echo "### Build failed" >&2
        exit 1
fi
