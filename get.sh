#!/usr/bin/env bash

# get.sh [version]
# download and unpack k runtime system.
# optional version tag is 'yyyy.mm.dd'.
# default is the latest available version.

IFS=$'\n'
read -d '' -ra x <<< "$(node get.js $1)"
dist=${x[0]}
eula=${x[1]}
test -z $dist || test -z $eula && exit 1
saved_crc=$(test -f shakti.eula.crc && cat shakti.eula.crc)
test -z $saved_crc && saved_crc=$(test -f /tmp/shakti.eula.crc && cat /tmp/shakti.eula.crc)
crc=$(printf "$eula" | cksum)
k=bin/k

download() {
    #printf "downloading $(basename "$dist")..."
    #curl -Ls $dist | tar -jxf - "bin/k" && printf "done.\n\n"
    mkdir -p bin && curl -Ls $dist > $k && chmod +x $k && ls -l $k || exit 1
}

if [ "$crc" == "$saved_crc" ] || [ -n "$CI" ];
then
    download
else
    #printf "no local crc found.\n"
    cols=$(stty size | cut -d ' ' -f 2)
    printf "\n$eula\n\n" | fold -s -w $(($cols - 10))
    while true
    do
        read -r -p "Do you agree with the terms of the Evaluation Agreement? [y/n] "
        case $REPLY in
        [yY][eE][sS]|[yY])
            printf "$crc" > shakti.eula.crc
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


#:~
