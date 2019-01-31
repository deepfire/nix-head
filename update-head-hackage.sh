#!/bin/sh
## Usage:                  Update head.hackage's checkout

git fetch --recursive
git submodule update --init
