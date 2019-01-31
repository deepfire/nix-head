#!/bin/sh

basename=$(basename $0)
nhroot="$(realpath $0 | xargs dirname)"

attr="$1"; shift
test -n "$attr" || { echo "USAGE: ${basename} ATTR" >&2; exit 1; }

verbose=""
while test -n "$1"
do case "$1" in
           --verbose ) verbose=yes;;
           "" ) break;;
   esac; shift; done

compiler=$(cat "${nhroot}/default-compiler.nix")

NIX_ARGS="-A pkgs.haskell.packages."${compiler}"."${attr}" ${nhroot}/nixpkgs.nix"
drv=$(nix-instantiate --quiet ${NIX_ARGS} "$@" || true)
if ! test -n "${drv}"
then
        echo "### Instantiation failed:" >&2
        cat $LOG >&2
        echo "### Instantiation failed" >&2
        exit 1
fi

cat <<EOF
             attr: ${attr}
         compiler: ${compiler}
 store derivation: ${drv}
           output: $(nix-store --query --binding out ${drv})
   src derivation: $(nix-store --query --binding src ${drv})
EOF

if test -n "${verbose}"
then cat <<EOF
           inputs:
EOF
nix-store --query --references ${drv}
fi
