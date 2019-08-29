#!/usr/bin/env bash

# USAGE: get.sh [version tag]
#
# DESCRIPTION: Download and unpack k binary from anaconda.org
# Use 'main', 'dev' or the release date in 'yyyy.mm.dd' format.
# The script downloads the latest 'dev' version by default.

IFS=$'\n'
read -d '' -ra x <<< "$(node get.js $1)"
dist=${x[0]}
eula=${x[1]}
test -z $dist || test -z $eula && exit 1
saved_crc=$(test -f eula.crc && cat eula.crc)
crc=$(printf "$eula" | cksum)

download() {
    printf "downloading $(basename "$dist") from anaconda.org..."
    curl -Ls $dist | tar -jxf - "bin/k" && printf "done.\n\n"
}

if [ "$crc" == "$saved_crc" ] || [ -n "$CI" ];
then
    download
else
    cols=$(stty size | cut -d ' ' -f 2)
    printf "$eula\n\n" | fold -s -w $(($cols - 4))
    while true
    do
        read -r -p "Do you agree with the terms of the Evaluation Agreement? [y/n] "
        case $REPLY in
        [yY][eE][sS]|[yY])
            printf "$crc" > eula.crc
            download
            break
        ;;
        [nN][oO]|[nN])
            printf "\n +------------------------+\n"
            printf   " |  installation aborted  |\n"
            printf   " +------------------------+\n\n"
            exit 1
            break
        ;;
        *)
            printf 'Please type "yes" or "no"\n'
        ;;
        esac
    done
fi
