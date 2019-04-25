#!/bin/bash

# This is a script that deletes files that no longer exist from the undo dir.

set -eu

echo "Going to clean in  ~/.undodir "
read -p "Continue?" -n1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "Cancelling"
	exit 1
fi

deleted_count=0
for file in ~/.undodir/*; do

	if [[ ! $(basename "$file") == %* ]]; then
		echo "File $(basename "$file") isn't a vim backup, skipping"
		continue
	fi

	undoname=$(basename $file)
	to_replace="${undoname//\%/\/}"
	# echo "Checking if file $to_replace exists..."
	if [[ ! -f "$to_replace" ]]; then
		echo  "$to_replace doesn't exist.  Deleting $file"
		deleted_count=$((deleted_count + 1))
		rm "$file"
	fi
done

echo "All done! $deleted_count files deleted"
