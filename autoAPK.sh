#!/bin/bash

<<<<<<< HEAD
dir=$1
=======
currentDir=$(dirname "$0")
>>>>>>> 9d0df64 (Updated)

# Function to display usage information
usage() {
    echo "Usage: $0 <directory_path>"
    exit 1
}
    
# Check if no arguments are passed
if [ $# -eq 0 ]; then
    usage
fi



# Step 1: Decompiling APKs in the main folder
for apkfile in "$dir"/*.apk; do
    if [ -f "$apkfile" ]; then
        filename=$(basename -- "$apkfile")
        foldername="${filename%.*}"
        
        echo "[x] Automation started on $filename"

        (
            apktool d "$apkfile" 

            echo "[x] $apkfile decompiled"
        )

        (
            python3 /home/cyrusop/tools/apkleaks/apkleaks.py -f "$apkfile" -o "${filename%.*}"_apkleaks

            echo "[x] Apkleaks scan finished"
        )&

        (
            nuclei -t mobileTemplates/ -o "$foldername"_nuclei < <(echo "$foldername")

            echo "[x] Nuclei scan finished"
        )&

        wait

<<<<<<< HEAD
=======
        # Step 3: Running apkleaks on APK files
        python3 ~/tools/apkleaks/apkleaks.py -f "$apkfile" -o "${filename%.*}"_apkleaks
>>>>>>> 9d0df64 (Updated)
    fi
done
