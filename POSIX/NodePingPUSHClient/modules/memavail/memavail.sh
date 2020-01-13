#!/usr/bin/env sh

os=$(uname)

if [ "$os" = "Linux" ]; then
    free -m | awk 'NR==2{printf  "%s", $7 }'
elif [ "$os" = "FreeBSD" ]; then
    free=$(top -d1 | grep "Mem" | awk '{ for (i=1;i<=NF;i++) if ($i == "Free") print $(i-1) }' | sed 's/[^0-9]/ /g')
    inact=$(top -d1 | grep "Mem" | awk '{ for (i=1;i<NF;i++) if ($i == "Inact,") print $(i-1) }' | sed 's/[^0-9]/ /g')

    echo $(( "$free" + "$inact" ))
elif [ "$os" = "OpenBSD" ]; then
    free=$(top -d1 | grep "Memory" | awk '{ for (i=1;i<NF;i++) if ($i == "Free:") print $(i+1) }' | sed 's/[^0-9]/ /g')
    cache=$(top -d1 | grep "Memory" | awk '{ for (i=1;i<NF;i++) if ($i == "Cache:") print $(i+1) }' | sed 's/[^0-9]/ /g')

    echo $(( $free + $cache ))
fi
