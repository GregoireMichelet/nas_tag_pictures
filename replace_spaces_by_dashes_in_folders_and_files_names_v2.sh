#!/bin/bash

# Check if a directory was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Get the directory from the first argument
input_dir="$1"

# Function to rename directories
rename_dirs() {
    find "$input_dir" -depth -type d -name "$1" | while IFS= read -r dir; do
        parent=$(dirname "$dir")
        newdir=$(basename "$dir" | sed "$2")
        cp --preserve=timestamps -r "$dir" "$parent/$newdir" && rm -r "$dir"
    done
}

# Function to rename files
rename_files() {
    find "$input_dir" -depth -type f -name "$1" | while IFS= read -r file; do
        parent=$(dirname "$file")
        newfile=$(basename "$file" | sed "$2")
        cp --preserve=timestamps "$file" "$parent/$newfile" && rm "$file"
    done
}

# Rename directories with spaces in their names
# We want to keep existing dashes in names >> first use to replace space by dash then replacing '---' by '-'
rename_dirs "* *" 's/ /-/g'
rename_dirs "*---*" 's/-\{2,\}/-/g'

# Rename files with spaces in their names
rename_files "* *" 's/ /-/g'

echo "Renaming completed."
