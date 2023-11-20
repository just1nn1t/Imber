#!/bin/bash

#Copyright © 2023 just1nn1t
#All rights reserved. This project is licensed under GitHub's default copyright laws,
#meaning that I retain all rights to my source code and no one may reproduce, distribute, or create derivative works from my work.

#you may change the hardcoded credentials
pwd_patt="^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$"

scan_dir() {
	local dir="$1"
	local origdir="$(pwd)"
	local opfile="cred.txt"
	
	#loop through content
	for item in "$dir"/*; do
		#if it's a file
		if [ -f "$item" ]; then
			find "$scanable" -type f -print0 | while IFS= read -r -d '' file; do
				if grep -qE "$pwd_patt" "$file"; then
					#append to the output file
					grep -E "$pwd_patt" "$file" >> "$opfile"
				fi
			done
		fi

		#if it's a directory
		elif [ -d "$item" ]; then
			scan_dir "$item"
		fi
	done
	
	cd "$origdir"
}


start_scan() {
	read -p "Enter the directory path to start scanning: " scanable
	
	#check if the dir exists
	if [ ! -d "$scanable" ]; then
		echo "Directory does not exist."
		exit 1
	fi
	
	scan_dir "$scanable"
}


cat << "EOF"

 ____  __  __  ____  ____  ____ 
(_  _)(  \/  )(  - \( ___)(  _ \
 _)(_  )    (  ) _ < )__)  )   /
(____)(_/\/\_)(____/(____)(_)\_)
                              by 1nn1t
--------------------------------------

EOF

echo

start_scan

echo "The scan has ended."
