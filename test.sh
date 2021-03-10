#!/bin/sh

# just to make sure
test ! -e get.sh || test ! -e get.js && exit 1

rm -rf bin eula.crc && ./get.sh

#:~
