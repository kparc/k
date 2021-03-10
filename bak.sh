#!/bin/sh

# retain eula checksum in /tmp to survive hard reinstall

test ! -e shakti.eula.crc && exit 0

cp shakti.eula.crc /tmp

#:~
