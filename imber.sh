#!/bin/bash

pwd_patt="^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$"

scan_dir() {
	local dir="$1"
	local orig_dir="$(pwd)"
 	local opfile="cred.txt"
	
	#loop through content
	for item in "$dir"/*; do
		#if it's a file
		if [ -f "$item" ]; then
            		find "$scanable" -type f -print0 | while IFS= read -r -d '' file; do
	                		if grep -qE "$pwd_patt" "$file"; then
						# Append to the output file
						grep -E "$pwd_patt" "$file" >> "$opfile"
	                		fi
           		 done
		fi

		#if it's a directory
		elif [ -d "$item" ]; then
			scan_dir "$item"
		fi
	done
	
	cd "$orig_dir"
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


loading() {
	chars="/-\|"
	sc=0
	dur=5
	end=$((SECONDS + dur))

	#SEC less than endtime
	while [ $SECONDS -lt $end ]; do
		printf "\r\b${chars:sc++:1} $1"
		
		#check to see if sc?=len(chars)
		((sc==${#chars})) && sc=0
		sleep 0.2
	done
	echo
}


cat << "EOF"
 ____  __  __  ____  ____  ____ 
(_  _)(  \/  )(  - \( ___)(  _ \
 _)(_  )    (  ) _ < )__)  )   /
(____)(_/\/\_)(____/(____)(_)\_)
                              by 1nn1t
EOF

echo
echo

loading "Loading..."

start_scan

echo "The scan has ended."
