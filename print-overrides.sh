#!/bin/sh

tracePatches=true
traceOverrides=true
case $1 in
     --patches-only   ) traceOverrides=false;;
     --overrides-only ) tracePatches=false;;
     "" )               true;;
     * ) echo "ERROR: unknown arg: $1" >&2; exit 1;;
esac

nix-instantiate shell.nix --arg tracePatches ${tracePatches} --arg traceOverrides ${traceOverrides}
