#!/bin/bash

# Check if a directory was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Get the directory from the first argument
SOURCE_FOLDER="$1"

# Check if the source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
  echo "Source folder does not exist"
  exit 1
fi

# Create the LOGS folder in the script's directory if it doesn't exist
LOGS_FOLDER="$SCRIPT_DIR/LOGS"
if [ ! -d "$LOGS_FOLDER" ]; then
  mkdir -p "$LOGS_FOLDER"
fi

# Create a log file with a timestamp
log_file="$LOGS_FOLDER/LOG_replace_spaces_by_dashes_in_folders_and_files_names_v3_$(date +%Y%m%d_%H%M%S).log"

# Function to rename directories
rename_dirs() {
    find "$SOURCE_FOLDER" -depth -type d -name "$1" | while IFS= read -r dir; do
        parent=$(dirname "$dir")
        newdir=$(basename "$dir" | sed "$2")
        cp --preserve=timestamps -r "$dir" "$parent/$newdir" && rm -r "$dir"
    done
}

# Function to rename files
rename_files() {
    find "$SOURCE_FOLDER" -depth -type f -name "$1" | while IFS= read -r file; do
        parent=$(dirname "$file")
        newfile=$(basename "$file" | sed "$2")
        cp --preserve=timestamps "$file" "$parent/$newfile" && rm "$file"
    done
}


###########################################################"

echo "START script : $0 at $(date +%Y%m%d_%H%M%S)" >> "$log_file"
echo "Executed in source folder : '$SOURCE_FOLDER'" >> "$log_file"

# Rename directories with spaces in their names
# We want to keep existing dashes in names >> first use to replace space by dash then replacing '---' by '-'

echo "--------------------------------" >> "$log_file"
echo "Step 1 : replacing spaces by '-'" >> "$log_file"
echo "--------------------------------"
echo "Step 1 : replacing spaces by '-'"

rename_dirs "* *" 's/ /-/g'

echo "--------------------------------" >> "$log_file"
echo "Step 2 : replacing '---' by '-'" >> "$log_file"
echo "--------------------------------"
echo "Step 2 : replacing '---' by '-'"

rename_dirs "*---*" 's/-\{2,\}/-/g'

# Rename files with spaces in their names
rename_files "* *" 's/ /-/g'

echo "--------------------------------" >> "$log_file"
echo "END script : $0 at $(date +%Y%m%d_%H%M%S)" >> "$log_file"
echo "Log file created at: $log_file" >> "$log_file"
echo "Renaming completed." >> "$log_file"

echo "--------------------------------"
echo "END script : $0 at $(date +%Y%m%d_%H%M%S)"
echo "Log file created at: $log_file"
echo "Renaming completed."
