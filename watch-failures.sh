#!/bin/sh
## Usage:                  Watch logs from all-failures{,-dialog}, as they come

echo -en "\ec"
tail -fn+0 $(dirname $0)/logs/recent-all-raw-failures.log

