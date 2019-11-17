#!/usr/bin/env python

import plistlib  # for parsing the plist files
import os  # for running the commands to generate lists
from pathlib import Path  # for home dir


# Set home
home = str(Path.home())


# Make text files of app data
os.system("` > ${HOME}/scripts/python/sysApps.txt")
os.system("brew cask list > ${HOME}/scripts/python/casks.txt")
    



with open(home + "/scripts/python/sysApps.txt", 'rb') as f:
    pl = plistlib.load(f)
    print(pl)
#print(pl["_name"])
    
#appname = pl['_name']
#obtainedfrom = pl['obtained_from']