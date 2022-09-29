#!/bin/bash

###################################################################
#Script Name	: convert-iso-8859-1-to-utf-8
#Description	: Script to convert files from ISO-8859-1 to UTF-8
# file encoding in a folder and all subfolders
# File types:
# java
# properties
# js
# json
# jsp
# jspx
# jsv
# jtpl
#Args           : Directory path or no arg for current directory
#Author       	: Luiz Fernando Severnini
###################################################################

# Default to search in current directory
BASEDIR="${PWD}"
ENCODING_FROM="ISO-8859-1"
ENCODING_TO="UTF-8"

# Check supplied directory
if [[ $# -eq 1 ]] ; then
	if [[ -d $1 ]]; then
		BASEDIR="$( realpath "$1" )"
	else
		echo "Supplied arg is not a directory: '$1'"
		exit 1
	fi
elif [[ $# -gt 1 ]] ; then
	echo "Illegal arg count '$#' - you must supply only one directory"
	exit 1
fi

echo "The script will run on \"${BASEDIR}\" and subfolders"
echo "Converting files from encoding ${ENCODING_FROM} to ${ENCODING_TO}"

sleep 2

# Filter files
#FILES=($(find . -type f -name "*.java" 2>/dev/null))
FILES=($(find $BASEDIR -regextype posix-egrep -regex ".*\.(java|properties|js|json|jsp|jspx|jsv|jtpl)$" 2>/dev/null))

converted_count=0

for file in "${FILES[@]}"; do
	filename="${file%.*}"

	# Get mime type of file
	if file -i $file | grep -iwq "${ENCODING_FROM}"; then
		# Convert to specified encoding
		iconv -f $ENCODING_FROM -t $ENCODING_TO $file > "${filename}_utf8"
		# Move the converted file to original file
		mv "${filename}_utf8" $file
		echo "CONVERTED TO UTF-8: ${file}"
		let converted_count++
	else
		echo "ALREADY IN UTF-8: ${file}"
	fi
done

echo "Done: ${converted_count} file(s) converted from encoding ${ENCODING_FROM} to ${ENCODING_TO}."
