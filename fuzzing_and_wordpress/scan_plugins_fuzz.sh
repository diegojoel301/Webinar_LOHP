#!/bin/bash

if [ ! -f plugins.txt ]
then
	wget https://raw.githubusercontent.com/Perfectdotexe/WordPress-Plugins-List/master/plugins.txt
fi

host="http://192.168.86.22/wordpress/wp-content/plugins/"

for fuzz in $(cat plugins.txt)
do
	state_code=$(curl -s -I -k $host$fuzz | tr -d '\r' | tr -d '\n' | awk '{print $2}')
	if [ $state_code != "404" ]; then
		echo "$host$fuzz -> plugin valido"
        fi
done
