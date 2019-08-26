#!/bin/bash
#===================================================================================
#
# FILE: get.sh
#
# USAGE: get.sh [version tag]
#
# DESCRIPTION: Download and unpack k binary from anaconda.org
# Use 'main', 'dev' or the release date in 'yyyy.mm.dd' format.
# The script downloads the latest 'dev' version by default.
#
# OPTIONS: see 'usage' and 'description'
# REQUIREMENTS: ---
# BUGS: ---
# NOTES: ---
# AUTHOR: regents of kparc, k@kparc.io
# COMPANY: kparc inc.
# VERSION: 1.1.1
# CREATED: 07.08.2019
# REVISION: 23.08.2019
#===================================================================================

u=$(node get.min.js url $1)                     # download url
test $? -ne 0 && echo "$u" && exit 1
sp=$(test -f sum.txt && cat sum.txt)            # last accepted license checksum
b=$(basename "$u")                              # archive file basename
test $? -ne 0 || test -z "$b" && echo "'url" && exit 1
set -e
l=$(node get.min.js eula)                       # license text
s=$(echo "$l" | cksum)                          # current license checksum
cd "$(dirname "$0")"

download () {                                   # download and unpack
    printf "downloading $b from anaconda.org..."
    curl -Ls $u | tar -jxf - "bin/k" && printf "done.\n\n"
}

if [ "$s" == "$sp" ] || [ -n "$CI" ];
then
    download
else
    COLUMNS=79
    eval $(resize)
    echo "$l" | fmt -w $(($COLUMNS - 4))
    while true
    do
        echo
        read -r -p "Do you agree with the terms of the Evaluation Agreement? [Y/n] " input
        case $input in
        [yY][eE][sS]|[yY])
            echo "$s" > sum.txt
            download
            break
        ;;
        [nN][oO]|[nN])
            echo "Aborting installation!"
            exit 1
            break
        ;;
        *)
            echo 'Please type "yes" or "no"'
        ;;
        esac
    done
fi
