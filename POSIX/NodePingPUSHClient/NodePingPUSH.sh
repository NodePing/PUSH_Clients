#!/usr/bin/env sh

url='https://push.nodeping.com/v1?id=CHECK_ID_HERE&checktoken=CHECK_TOKEN_HERE'
debug=0
log=0

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
	
done < 'moduleconfig'

json="{\"data\":{$json}}"

if [ $debug = 1 ]
then
	echo $json
else

	if [ $log = 1 ]
	then
		echo "$(date) => $json" >> NodePingPUSH.log
	fi
	
	response=$(curl -s -w "%{http_code}" -X POST -H "Content-Type: application/json" --data "$json" "$url")
	code=$(echo "$response" | tail -n1)
	response=$(echo "$response" | sed '$d')
	
	if [ $log = 1 ]
	then
		echo "$(date) <= $code $response" >> NodePingPUSH.log
	fi
	
fi
#
