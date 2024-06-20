#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$0")

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 source_folder tag"
  echo "Script to tag all pictures in a folder with a specific tag using exiftool"
  exit 1
fi

SOURCE_FOLDER=$1
TAG=$2

# Check if the second argument matches either "Mes-photos" or "Whatsapp"
if [[ "$TAG" != "Mes-photos" && "$TAG" != "Whatsapp" ]]; then
  echo "Second argument must be either 'Mes-photos' or 'Whatsapp'"
  exit 1
fi

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
log_file="$LOGS_FOLDER/LOG_nas_tag_pictures_v2_$(date +%Y%m%d_%H%M%S).log"

echo "START script : nas_tag_pictures_v2 at $(date +%Y%m%d_%H%M%S)" >> "$log_file"
echo "Executed in source folder : '$SOURCE_FOLDER'" >> "$log_file"
echo "START script : nas_tag_pictures_v2 at $(date +%Y%m%d_%H%M%S)"
echo "Executed in source folder : '$SOURCE_FOLDER'"

echo "--------------------------------" >> "$log_file"
echo "Step 1 : finding all files that do not have '$TAG' in their subject" >> "$log_file"
echo "--------------------------------" >> "$log_file"
echo "--------------------------------"
echo "Step 1 : finding all files that do not have '$TAG' in their subject"

exiftool -if "not \$XMP-dc:Subject=~/${TAG}/" -r "$SOURCE_FOLDER" -T -directory -filename | awk '{print $1 "/" $2}' > "$SCRIPT_DIR/not_matching_files.txt"

# Exclude lines ending with '-' or containing '@eaDir'
grep -Ev '(\-$|@eaDir)' not_matching_files.txt > cleaned_not_matching_files.txt

line_count=$(wc -l < "$SCRIPT_DIR/cleaned_not_matching_files.txt")
echo "Count of files found : $line_count" >> "$log_file"
echo "Count of files found : $line_count"

# Check if line_count is 0 and exit the script if true
if [ "$line_count" -eq 0 ]; then
    echo "--------------------------------" >> "$log_file"
    echo "No files found without the tag. Exiting." >> "$log_file"
    echo "--------------------------------"
    echo "No files found without the tag. Exiting."
    rm "$SCRIPT_DIR/not_matching_files.txt"
    exit 1
fi

echo "--------------------------------"
echo "Step 2 : removing all existing subjects on those files"

export SOURCE_FOLDER

# Remove all existing subjects for all files in the destination folder and redirect output to log file
cat not_matching_files.txt | xargs -I {} exiftool -r -v -overwrite_original -XMP:Subject= "{}" >> "$log_file" 2>&1

echo "--------------------------------" >> "$log_file"
echo "Step 3 : adding the new TAG : '$TAG'" >> "$log_file"
echo "--------------------------------" >> "$log_file"
echo "--------------------------------"
echo "Step 3 : adding the new TAG : '$TAG'"

# Add the new TAG to the XMP IPTC "Subject" metadata for all files in the destination folder and redirect output to log file
cat not_matching_files.txt | xargs -I {} exiftool -r -v -overwrite_original -XMP:Subject+="$TAG" "{}" >> "$log_file" 2>&1

echo "--------------------------------" >> "$log_file"
echo "END script : nas_tag_pictures_v2 at $(date +%Y%m%d_%H%M%S)" >> "$log_file"

# Removing not_matching_files.txt file
rm "$SCRIPT_DIR/not_matching_files.txt"
rm "$SCRIPT_DIR/cleaned_not_matching_files.txt"

# Print log file location
echo "--------------------------------"
echo "END script : nas_tag_pictures_v2 at $(date +%Y%m%d_%H%M%S)"
echo "Log file created at: $log_file"
