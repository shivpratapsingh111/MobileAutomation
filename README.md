# I have created this to automate android pentest at mass level [Project is in it's initial stage]
## download.py is to download apk files from apkmonk
- To Download more than one APK files use -f flag followed by txt filename containing package name one per line. [In below example pkg.txt contains package names of APKs]
  
  `python3 download.py -f pkg.txt`
- To Download single APK file use -p flag followed by the package name of the APK. [In below example com.example.android is package name]
  
  `python3 download.py -p com.example.android`    
## autoAPK is bash script to automate android pentesting on mass level
- To automate pentest on APK files, put them in a single directory and use below command. [In below example Apkfiles/ is directory path having all APK files in it]
  
  `./autoAPK -d Apkfiles/`
  
    - Apkleaks
    - Nuclei

## TODO

- Add this:
``` https://d.apkpure.net/b/APK/{PACKAGE_NAME}?version=latest ```