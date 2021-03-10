#!/bin/sh

# just to make sure
test -z get.sh || test -z get.js && exit 1

rm -rf bin eula.crc && ./get.sh

#:~
