#!/bin/bash

#Copyright © 2023 just1nn1t
#All rights reserved. This project is licensed under GitHub's default copyright laws,
#meaning that I retain all rights to my source code and no one may reproduce, distribute, or create derivative works from my work.
#This tool is meant for research and educational purposes only and any malicious usage of this tool is prohibited.

#you may change the hardcoded credentials
patt=("awk '/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$/'")

scandir() {
	local dir="$1"
	local origdir="$(pwd)"
	local opfile="cred.txt"
	
	#loop through content
	for item in "$dir"/*; do
		#if it's a file
		if [ -f "$item" ]; then
			find "$scanable" -type f -print0 | while IFS= read -r -d '' file; do
				if grep -qE "$patt" "$file"; then
					#append to the output file
					grep -E "$patt" "$file" >> "$opfile"
				fi
			done
		fi

		#if it's a directory
		elif [ -d "$item" ]; then
			scandir "$item"
		fi
	done
	
	cd "$origdir"
}


startscan() {
	read -p "Enter the directory path to start scanning: " scanable
	
	#check if the dir exists
	if [ ! -d "$scanable" ]; then
		echo "\e[91mDirectory does not exist.\e[0m"
		exit 1
	fi
	
	scandir "$scanable"
}


cat << "EOF"
  

 ██▓ ███▄ ▄███▓ ▄▄▄▄   ▓█████  ██▀███  
▓██▒▓██▒▀█▀ ██▒▓█████▄ ▓█   ▀ ▓██ ▒ ██▒
▒██▒▓██    ▓██░▒██▒ ▄██▒███   ▓██ ░▄█ ▒
░██░▒██    ▒██ ▒██░█▀  ▒▓█  ▄ ▒██▀▀█▄  
░██░▒██▒   ░██▒░▓█  ▀█▓░▒████▒░██▓ ▒██▒
░▓  ░ ▒░   ░  ░░▒▓███▀▒░░ ▒░ ░░ ▒▓ ░▒▓░
 ▒ ░░  ░      ░▒░▒   ░  ░ ░  ░  ░▒ ░ ▒░
 ▒ ░░      ░    ░    ░    ░     ░░   ░ 
 ░         ░    ░         ░  ░   ░     
                     ░                 
                           by 1nn1t

EOF

echo

startscan

echo "The scan has ended."
