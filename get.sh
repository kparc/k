#!/usr/bin/env bash

# get.sh [version]
# download and unpack k runtime and dev environment.
# optional version tag is 'yyyy.mm.dd' (nyi).
# default is the latest available version.
# fetches content from shakti.sh into ~/shakti if it exists.

# re-tty (npm 7.*)
t=/dev/tty; exec>$t<$t

k=bin/k
devpath=~/shakti
eula_path=../.shakti.eula.crc
#INSECURE=--insecure

fetch(){
    ft=$1; test -z $ft && return
    CD=`pwd`; cd $devpath
    curl -f -z $ft -Ls --create-dirs -o $ft http://shakti.com/$ft && printf "[~] $devpath/$ft\n"
    cd $CD
}

if [[ "$EUID" > 0 && -d $devpath ]]; then
    paths=`node --no-warnings get.js dev > shakti.lst`; test $? -eq 0 || exit 1
    cat shakti.lst | xargs -L1 | while read p ; do fetch $p ; done
fi

exit 0

IFS=$'\n'
read -d '' -ra x <<< "$(node --no-warnings get.js $1)"
dist=${x[0]}; eula=${x[1]}

test -z $dist || test -z $eula && exit 1
saved_crc=$(test -f $eula_path && cat $eula_path)
crc=$(printf "$eula" | cksum)

download() {
    printf "downloading $(basename "$dist")..."
    #curl -Ls $dist | tar -jxf - "bin/k" && printf "done.\n\n"
    mkdir -p bin && curl $INSECURE -Ls $dist > $k && chmod +x $k && echo .z.a|bin/k && echo || exit 1
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
	printf "\nDo you agree with the terms of the Shakti Software Evaluation Agreement? [y/n] " && read -rn1

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
