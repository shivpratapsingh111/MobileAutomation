#!/bin/bash

dir=$1

# Function to display usage information
usage() {
    echo "Usage: $0 <directory_path>"
    exit 1
}

# Check if no arguments are passed
if [ $# -eq 0 ]; then
    usage
fi


# Function to process a single APK file
processApkFile() {
    apkfile="$1"
    if [ -f "$apkfile" ]; then
        filename=$(basename -- "$apkfile")
        foldername="${filename%.*}"
        
        # Step 1: Decompiling APKs in the main folder
        apktool d "$apkfile"
        
        # Step 2: Running nuclei on decompiled folders
        nuclei -t mobileTemplates/ -o "$foldername"_nuclei < <(echo "$foldername")
        
        # Step 3: Running apkleaks on APK files
        python3 /home/cyrusop/tools/apkleaks/apkleaks.py -f "$apkfile" -o "${filename%.*}"_apkleaks
    fi
}

# Export the functions to make them available to GNU Parallel
export -f processApkFile

# Process each APK file in parallel
parallel --jobs 5 processApkFile ::: "$dir"/*.apk

clear
echo "[x] Automation done for all APKs"