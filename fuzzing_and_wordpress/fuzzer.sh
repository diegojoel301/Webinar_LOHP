#!/bin/bash

if [ $# -eq 2 ]
then
	host=$1

	#for fuzz in $(cat /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt); do
	for fuzz in $(cat $2)
	do
		state_code=$(curl -s -I -k $host/$fuzz | tr -d '\r' | tr -d '\n' | awk '{print $2}')
		if [ $state_code != "404" ]; then
			echo "$host/$fuzz -> $state_code"
		fi
	done
else
	echo "[!] Ejecutalo asi:"
	echo -e "\t./fuzzer.sh http(s)://<host>/ <diccionario>"
fi
