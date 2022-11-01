#!/usr/bin/env sh

CHECK_ID=""
CHECK_TOKEN=""
# Log file location
logfilepath="$(dirname $0)/NodePingPUSH.log"
# Location of modules
MODULESPATH="$(dirname $0)/modules"
debug=0
log=0
retries=3
timeout=5

url="https://push.nodeping.com/v1?id=$CHECK_ID&checktoken=$CHECK_TOKEN"
pathtomoduleconfig="$(dirname $0)/moduleconfig"
for var in "$@"
do
    case $var in
    	-d | -debug)
    		debug=1
    		;;
    	-l | -log)
    		log=1
    		;;
	esac
done

json=''

while read -r module
do
	result=$(sh $MODULESPATH/$module/$module.sh)

	if [ -z "$json" ]
	then
		json="\"$module\":$result"
	else
		json="$json,\"$module\":$result"
	fi

done < "$pathtomoduleconfig"

json="{\"data\":{$json}}"

if [ $debug = 1 ]
then
	echo $json
else

	if [ $log = 1 ]
	then
		echo "$(date) => $json" >> $logfilepath
	fi

	response=$(curl --connect-timeout $timeout -s --retry $retries  -w "%{http_code}" -X POST -H "Content-Type: application/json" --data "$json" "$url")
	code=$(echo "$response" | tail -n1)
	# 200 means it went through successfully, 409 means throttled, but it still connected
	good_response=$(echo $response | grep -c -E '200|409')
	response=$(echo "$response" | sed '$d')
fi

if [ $log = 1 ]
then
	echo "$(date) <= $code $response" >> $logfilepath
fi
#
