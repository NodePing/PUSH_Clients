#!/usr/bin/env sh

# Get the rx_bytes and tx_bytes for each interface and calculate the
# speeds based on an X second sample, or since the last run by viewing
# a stored rx/tx value from the last run

. $(dirname $0)/variables.sh


sep=''
echo '{'

# If the value wants to be compared between pushes, this will be true
if [ $each_push = "true" ]; then
    # Checks for file. Creates it if not present
    if [ ! -f "$interface_info" ]; then
        touch "$interface_info"
    fi
fi

# Checks network utilization per interface
for interface in $interfaces; do 

    echo "$sep"

    # If there is an existing entry and each_push, gather the info
    if [ $(grep -c "$interface" "$interface_info") = 1 ] && [ $each_push = "true" ]; then
        last_rx=$(grep "$interface" "$interface_info" | awk '{print $2}')
        last_tx=$(grep "$interface" "$interface_info" | awk '{print $3}')
    # If it doesn't exist and each_push, collect from sys and sleep a few seconds
    elif [ $(grep -c "$interface" "$interface_info") = 0 ] && [ $each_push = "true" ]; then
        last_rx=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
        last_tx=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
        # Sleep an initial 5 seconds to gather fresh data
        sleep 5
    # Otherwise each_push isn't true and we will gather the average over a specified time
    else
        last_rx=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
        last_tx=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
        sleep $sleep_interval
    fi

    # Get current values
    current_rx=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
    current_tx=$(cat "/sys/class/net/$interface/statistics/tx_bytes")

    # On reboot the new rx/tx values will be smaller than what is stored
    # This will get new values and provide a proper result
    if [ $current_rx -lt $last_rx ]; then
        last_rx=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
        last_tx=$(cat "/sys/class/net/$interface/statistics/tx_bytes")

        sleep 5

        current_rx=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
        current_tx=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
   fi

    # Get current received and transferred packets in mbps
    # rx=$(echo $last_rx $current_rx $sleep_interval  | awk '{printf "%0.2f",(($2 - $1)/$3)/1048576}')
    # tx=$(echo $last_tx $current_tx $sleep_interval  | awk '{printf "%0.2f",(($2 - $1)/$3)/1048576}')
    rx_percent=$(echo $last_rx $current_rx $sleep_interval  | awk '{printf "%0.2f",(($2 - $1)/$3)/1000000}')
    tx_percent=$(echo $last_tx $current_tx $sleep_interval  | awk '{printf "%0.2f",(($2 - $1)/$3)/1000000}')
    rx_bytes=$(($current_rx - $last_rx))
    tx_bytes=$(($current_tx - $last_tx))
   
    # Gets the percentage of network utilization
    rx_utilization=$(echo "$rx_percent $expected_net_utilization_rx" | awk '{printf ($1 / $2)*100}')
    tx_utilization=$(echo "$tx_percent $expected_net_utilization_tx" | awk '{printf ($1 / $2)*100}')
    echo "\"$interface\":{\"rx_percent\":$rx_utilization,\"tx_percent\":$tx_utilization,\"rx_bytes\":$rx_bytes,\"tx_bytes\":$tx_bytes}"

    # Writes new values to the last_values.txt file if feature is being used
    if [ $each_push = "true" ] && [ $(grep -c "$interface" "$interface_info") = 1 ]; then
        oldline=$(grep "$interface" "$interface_info")
        newline="$interface $current_rx $current_tx"
        sed -i "s/$oldline/$newline/g" "$interface_info"
    elif [ $each_push = "true" ] && [ $(grep -c "$interface" "$interface_info") = 0 ]; then
        echo "$interface $current_rx $current_tx" >> "$interface_info"
    fi
    
    sep=','
done
echo '}'
