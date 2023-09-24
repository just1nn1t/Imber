#!/bin/bash

usr_name_patt="username[[:space:]]*=[[:space:]]*"
pwd_patt="^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$"

scan_dir() {
	local dir="$1"
	local orig_dir="$(pwd)"
	
	#loop through content
	for item in "$dir"/*; do
		#if it's a file
		if [ -f "$item" ]; then
            find "$scanable" -type f -print0 | while IFS= read -r -d '' file; do
                if grep -qE "$usr_name_patt" "$file" && grep -qE "$pwd_patt" "$file"; then
                    grep -E "$usr_name_patt|$pwd_patt" "$file"
                fi
            done
        fi

		#if it's a directory
		elif [ -d "$item" ]; then
			scan_dir "$item"
		fi
	done
	
	#after scanning the subdir, return to the original
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

start_scan
