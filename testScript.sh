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


automate(){

    apkfile=$1
    filename=$(basename "$apkfile")
    foldername="${filename%.*}"

    apktool d "$apkfile"
    nuclei -t mobileTemplates/ -c 100 -o "$foldername"_nuclei < <(echo "$foldername")
    python3 /home/cyrusop/tools/apkleaks/apkleaks.py -f "$apkfile" -o "${filename%.*}"_apkleaks

}


# Step 1: Decompiling APKs in the main folder
for apkfile in "$dir"/*.apk; do
    if [ -f "$apkfile" ]; then

        automate $apkfile
        

    fi
done
