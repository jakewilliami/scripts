#!/usr/bin/env python
#Rub using `python3 ${HOME}/scripts/python/applications.py`

import plistlib  # for parsing the plist files
import os  # for running the commands to generate lists
from pathlib import Path  # for home dir


# Set home
home = str(Path.home())


# Make text files of app data
os.system("` > ${HOME}/scripts/python/temp.d/sysApps.txt")
os.system("brew cask list > ${HOME}/scripts/python/temp.d/casks.txt")
    



with open(home + "/scripts/python/temp.d/sysApps.txt", 'rb') as f:
    pl = plistlib.load(f)
    print(pl)
#print(pl["_name"])
    
#appname = pl['_name']
#obtainedfrom = pl['obtained_from']