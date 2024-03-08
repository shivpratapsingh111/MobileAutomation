#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 -d <directory_path>"
    echo "Options:"
    echo "  -d, --directory <directory_path>    Specify the directory path containing APK files"
    exit 1
}

# Check if no arguments are passed
if [ $# -eq 0 ]; then
    usage
fi

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -d|--directory)
            main_directory="$2"
            shift
            shift
            ;;
        *)
            # Unknown option
            echo "Error: Unknown option: $1"
            usage
            ;;
    esac
done

# Check if main directory is provided
if [ -z "$main_directory" ]; then
    echo "Error: Main directory not provided."
    usage
fi

# Step 1: Decompiling APKs in the main folder
for apkfile in "$main_directory"/*.apk; do
    if [ -f "$apkfile" ]; then
        filename=$(basename -- "$apkfile")
        foldername="${filename%.*}"
        apktool d "$apkfile"

        # Step 2: Running nuclei on decompiled folders
        nuclei -t mobileTemplates/ -o "$foldername"_nuclei < <(echo "$foldername")

        # Step 3: Running apkleaks on APK files
        python3 ~/tools/apkleaks.py -f "$apkfile" -o "${filename%.*}"_apkleaks
    fi
done
