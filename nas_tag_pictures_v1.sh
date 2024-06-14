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
log_file="$LOGS_FOLDER/LOG_nas_tag_pictures_v1_$(date +%Y%m%d_%H%M%S).log"

echo "START script : nas_tag_pictures_v1 at $(date +%Y%m%d_%H%M%S)" >> "$log_file"
echo "--------------------------------" >> "$log_file"
echo "START executing exiftool at $(date +%Y%m%d_%H%M%S)" >> "$log_file"
echo "--------------------------------" >> "$log_file"

export SOURCE_FOLDER

# Remove all existing subjects for all files in the destination folder and redirect output to log file
exiftool -r -overwrite_original -XMP:Subject= "$SOURCE_FOLDER" >> "$log_file" 2>&1

echo "--------------------------------" >> "$log_file"

# Add the new TAG to the XMP IPTC "Subject" metadata for all files in the destination folder and redirect output to log file
exiftool -r -overwrite_original -XMP:Subject+="$TAG" "$SOURCE_FOLDER" >> "$log_file" 2>&1

echo "--------------------------------" >> "$log_file"
echo "END script : nas_tag_pictures_v1 at $(date +%Y%m%d_%H%M%S)" >> "$log_file"

# Print log file location
echo "--------------------------------"
echo "Log file created at: $log_file"
