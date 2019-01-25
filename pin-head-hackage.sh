#!/bin/sh

rev=$1
test -n "${rev}" || {
        echo "USAGE: $(basename $0) COMMIT-ID [GITHUB-USERNAME]" >&2
        exit 1
}

upstream=${2:-hvr}
repo="head.hackage"

set -e

cd ${repo}
git diff --exit-code || {
        echo "ERROR: working tree '${repo}' unclean, refusing to proceed." >&2
        exit 1
}

git fetch https://github.com/${upstream}/${repo}/
git reset --hard  ${rev}
cd -

git add ${repo}
