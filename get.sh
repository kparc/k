#!/bin/bash

# USAGE: get.sh [version tag]
#
# DESCRIPTION: Download and unpack k binary from anaconda.org
# Use 'main', 'dev' or the release date in 'yyyy.mm.dd' format.
# The script downloads the latest 'dev' version by default.

cd "$(dirname $0)"
u=$(node get.js url $1)
test $? -ne 0 && printf "$u\n" && exit 1
sp=$(test -f eula.crc && cat eula.crc)
b=$(basename "$u")
test $? -ne 0 || test -z "$b" && printf "'url\n" && exit 1
l=$(node get.js eula)
test $? -ne 0 && printf "$l\n" && exit 1
s=$(printf "$l" | cksum)

download () {
    printf "downloading $b from anaconda.org..."
    curl -Ls $u | tar -jxf - "bin/k" && printf "done.\n\n"
}

if [ "$s" == "$sp" ] || [ -n "$CI" ];
then
    download
else
    cols=$(stty size | cut -d ' ' -f 2)
    printf "$l\n\n" | fmt -w $(($cols - 4))
    while true
    do
        read -r -p "Do you agree with the terms of the Evaluation Agreement? [y/n] " input
        case $input in
        [yY][eE][sS]|[yY])
            printf "$s" > eula.crc
            download
            break
        ;;
        [nN][oO]|[nN])
            printf "\n -------------------------- \n"
            printf " |  installation aborted  | \n"
            printf " -------------------------- \n\n"
            exit 1
            break
        ;;
        *)
            printf 'Please type "yes" or "no"\n'
        ;;
        esac
    done
fi
