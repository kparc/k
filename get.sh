#!/usr/bin/env bash

# get.sh [version]
# download and unpack k runtime system.
# optional version tag is 'yyyy.mm.dd'.
# default is the latest available version.


# re-tty (npm 7.*)
t=/dev/tty
exec>$t<$t

IFS=$'\n'
read -d '' -ra x <<< "$(node get.js $1)"
dist=${x[0]}
eula=${x[1]}
eula_path=/tmp/shakti.eula.crc
test -z $dist || test -z $eula && exit 1
saved_crc=$(test -f $eula_path && cat $eula_path)
crc=$(printf "$eula" | cksum)
k=bin/k

download() {
    #printf "downloading $(basename "$dist")..."
    #curl -Ls $dist | tar -jxf - "bin/k" && printf "done.\n\n"
    mkdir -p bin && curl -Ls $dist > $k && chmod +x $k || exit 1
}

if [ "$crc" == "$saved_crc" ] || [ -n "$CI" ];
then
    download
else
    #printf "no local crc found.\n"
    cols=$(stty size | cut -d ' ' -f 2)
    printf "\n\n$eula\n" | fold -s -w $(($cols - 10))
    while true
    do
	printf "\nDo you agree with the terms of the Evaluation Agreement? [y/n] " && read -rn1

        case $REPLY in
        [yY][eE][sS]|[yY])
            printf "$crc" > $eula_path
            printf "\n\n"
            download
            break
        ;;
        [nN][oO]|[nN])
            printf "\n\n +------------------------+\n"
            printf   " |  installation aborted  |\n"
            printf   " +------------------------+\n\n"
            exit 1
            break
        ;;
        *)
            printf '\nPlease type "yes" or "no".\n'
        ;;
        esac
    done
fi

#:~
