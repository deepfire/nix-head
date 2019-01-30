#!/bin/sh

echo -en "\ec"
tail -fn+0 $(dirname $0)/logs/recent-all-raw-failures.log

