#!/bin/bash

# Check if a directory was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Get the directory from the first argument
input_dir="$1"

# Find and rename directories with spaces in their names
find "$input_dir" -depth -type d -name "* *" | while IFS= read -r dir; do
    parent=$(dirname "$dir")
    newdir=$(basename "$dir" | sed 's/ /-/g')
    mv "$dir" "$parent/$newdir"
done

# Find and rename directories with spaces in their names
find "$input_dir" -depth -type d -name "*---*" | while IFS= read -r dir; do
    parent=$(dirname "$dir")
    newdir=$(basename "$dir" | sed 's/-\{2,\}/-/g')
    mv "$dir" "$parent/$newdir"
done

# Find and rename files with spaces in their names
find "$input_dir" -depth -type f -name "* *" | while IFS= read -r file; do
    parent=$(dirname "$file")
    newfile=$(basename "$file" | sed 's/ /-/g')
    mv "$file" "$parent/$newfile"
done

echo "Renaming completed."
