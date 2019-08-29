#!/bin/bash

# USAGE: get.sh [version tag]
#
# DESCRIPTION: Download and unpack k binary from anaconda.org
# Use 'main', 'dev' or the release date in 'yyyy.mm.dd' format.
# The script downloads the latest 'dev' version by default.

cd "$(dirname $0)"
node get.js $1
IFS=$'\n===\n' read -d '' -ra x <<< "$(node get.js $1)"
echo "$?"
#test $? -ne 0 && exit 1
dist=${x[0]}
eula=${x[1]}
printf "$dist $eula"
sp=$(test -f eula.crc && cat eula.crc)
b=$(basename "$dist")
test $? -ne 0 || test -z "$b" && printf "'url\n" && exit 1
s=$(printf "$eula" | cksum)

download () {
    printf "downloading $b from anaconda.org..."
    curl -Ls $dist | tar -jxf - "bin/k" && printf "done.\n\n"
}

if [ "$s" == "$sp" ] || [ -n "$CI" ];
then
    download
else
    cols=$(stty size | cut -d ' ' -f 2)
    printf "$eula\n\n" | fold -s -w $(($cols - 4))
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
