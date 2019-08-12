#!/bin/sh

u=$(node url.js $1)
b=$(basename $u)

test $? -ne 0 || test -z "$b" && echo "\`url" && exit 1
printf "downloading $(basename $u) from anaconda.org..."
rm -rf "/tmp/$b" && mkdir "/tmp/$b"
curl -LGs $u | tar --directory "/tmp/$b" -jxf - "info/LICENSE.txt" "bin/k" && printf "done.\n\n"
COLUMNS=79
eval $(resize)
fmt -w $(($COLUMNS - 4)) "/tmp/$b/info/LICENSE.txt"
while true
do
    read -r -p "Do you agree with the terms of the Evaluation Agreement? [Y/n] " input
    case $input in
        [yY][eE][sS]|[yY])
    chmod +x /tmp/$b/bin/k
    mv "/tmp/$b/bin/k" .
    #echo && ls -la ./k
    #echo "done"
    break
    ;;
        [nN][oO]|[nN])
    echo "Aborting installation!"
    rm -r "/tmp/$b"
    exit 1
    break
    ;;
        *)
    echo "Please type \"yes\" or \"no\""
    ;;
    esac
done

rm -r "/tmp/$b"
