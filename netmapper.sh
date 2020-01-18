#!/bin/bash

# Ask for input from the user to specifiy what network to Enumerate
read -p "Enter Network you wish to Enumerate XXX.XXX.XXX: " network

# Ask user for range of IPs they wish to Enumerate in case they don't wish to check all 255 possibilities.
read -p "Enter range of IPs you wish to Enumerate XX XX: " min max

# Set 4th octet variable for loops
Oct4=$min

# Define ports to check for
ports=(20 21 22 25 43 53 69 79 80 88 110 111 115 118 137 138 139 156 220 443 513 514 543)

# While the 4th octet of the IP Address is greater than the users specified Minimum and less than the Maximum loop.
while [ $Oct4 -ge $min ] && [ $Oct4 -le $max ]
do

	# Set variable ipAddress equal to a concatenation of network.oct4 creating a 4 octet IP Address.
	ipAddress="$network.$Oct4"
	
	# Ping the IP Address with a timeout of one tenth of a second and throw away reply information
	timeout 0.1 ping -c 1 $ipAddress > /dev/null
	
	# If the ping was successful tell user host is valid and run a for loop checking well known ports to see if they are open.
	if [ $? -eq 0 ]
	then
		echo "$ipAddress is a valid host; Ports host has open: "
		for portNumber in ${ports[*]}
		do
			# Send empty string to ports to determine if they are listening. Lost echoes or non-replies are thrown away as they
			# are unimportant.
			(echo ""  > /dev/tcp/$ipAddress/$portNumber) 2> /dev/null
			if [ $? -eq 0 ]
			then
				echo "Port $portNumber is Open."
			fi
		done
	fi

	# After completion of the loop iteration increment 4th octet by 1 and loop again.
	Oct4=`expr $Oct4 + 1`
done
