#!/usr/bin/env sh

url='https://push.nodeping.com/v1?id=CHECK_ID_HERE&checktoken=CHECK_TOKEN_HERE'
pathtomoduleconfig='/full/path/to/moduleconfig'
logfilepath='/full/path/to/logfile/NodePingPUSH.log'
debug=0
log=0
retries=3
timeout=5

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

while IFS=$'=' read -r module filename
do

	result=$($filename);

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

	# Tries to connect once and then retries if fails $retries more times
	tries=$(($retries + 1))

	while [ $tries -gt 0 ]
	do
		response=$(curl --connect-timeout $timeout -s -w "%{http_code}" -X POST -H "Content-Type: application/json" --data "$json" "$url")
		code=$(echo "$response" | tail -n1)
		# 200 means it went through successfully, 409 means throttled, but it still connected
		good_response=$(echo $response | grep -c -E '200|409')
		response=$(echo "$response" | sed '$d')

		# If no 200 or 409, subract from our retry count. Otherwise, break from the loop and continue
		if [ $good_response = 0 ]
		then
			tries=$(($tries - 1))
		else
			break
		fi
	done
fi

if [ $log = 1 ]
then
	echo "$(date) <= $code $response" >> $logfilepath
fi
#
