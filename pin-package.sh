#!/bin/sh

github_user=$1; shift

nhroot="$(realpath $0 | xargs dirname)"
cwdRepo="$(basename $(pwd))"

repo=${2:-${cwdRepo}}
rev=${3:-$(if test "${cwdRepo}" = "${repo}"; then git rev-parse HEAD; fi)}


case ${github_user} in
    local | home ) base=file://$HOME; github_user='';;
    * )            base=https://github.com/ ;;
esac
nix-prefetch-git ${base}${github_user}/${repo} ${rev} | tee "${nhroot}"/pins/${repo}.src-json

