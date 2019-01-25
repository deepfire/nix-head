#!/bin/sh

github_user=$1
repo=$2
rev=$3

case ${github_user} in
    local | home ) base=file://$HOME; github_user='';;
    * )            base=https://github.com/ ;;
esac
nix-prefetch-git ${base}${github_user}/${repo} ${rev} > $(dirname $0)/pins/${repo}.src.json

