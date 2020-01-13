#!/usr/bin/env sh

os=$(uname)

if [ "$os" = "Linux" ]; then
    free -m | awk 'NR==2{printf  "%s", $7 }'
elif [ "$os" = "FreeBSD" ]; then
    free=$(top -d1 | grep "Mem" | awk '{ for (i=1;i<=NF;i++) if ($i == "Free") print $(i-1) }' | sed 's/[^0-9]/ /g')
    inact=$(top -d1 | grep "Mem" | awk '{for (i=1;i<NF;i++) if ($i == "Inact,") print$(i-1) }' | sed 's/[^0-9]/ /g')

    echo $(( "$free" + "$inact" ))
elif [ "$os" = "OpenBSD" ]; then
    top -d1 | grep Mem | awk '{ print $6,$8 }' | sed 's/[^0-9]/ /g' | awk '{ print $1 + $2 }'
fi
