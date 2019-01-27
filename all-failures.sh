#!/bin/sh

fullog="$(dirname $0)/logs/recent-all-raw-failures.log"

cat >&2 <<EOF
Hello there, stderr reporting!
Will print store paths of failed derivations to stdout.
To see   a faillog:   nix log FAILED-DRV-STORE-PATH
To see the full log:  tail -f ${fullog}
EOF

$(dirname $0)/all-raw-failures.sh                      2>&1 |
tee ${fullog}                                               |
grep --line-buffered        'failed with exit code'         |
sed "s/^builder for '\(.*\)' failed with exit code .*$/\1/" |
tee $(dirname $0)/logs/recent-all-drvs-failures.log
