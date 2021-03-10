#!/bin/sh

# retain EULA checksum in /tmp to survive hard reinstall

test ! -e eula.crc && exit 0

cp eula.crc /tmp

#:~
