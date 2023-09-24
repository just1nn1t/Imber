#!/bin/bash

usr_patt="username[[:space:]]*=[[:space:]]*"
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
                		if grep -qE "$usr_patt" "$file" && grep -qE "$pwd_patt" "$file"; then
		  			# Append to the output file
                    			grep -E "$usr_patt|$pwd_patt" "$file" >> "$opfile"
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

spinner="/-\|"

echo -n "Loading... "
while true; do
    for i in ${spinner}; do
        echo -n "$i"
        echo -en "\b"
        sleep 0.1
    done
done
}

loading

start_scan

echo "The scan has ended."