#!/usr/bin/env python
# Run using `python3 ${HOME}/scripts/python/applications.py`

import plistlib  # for parsing the plist files
import os  # for running the commands to generate lists
from pathlib import Path  # for home dir


# Set home
home = str(Path.home())


# Make text files of app data
os.system("system_profiler -xml SPApplicationsDataType > ${HOME}/scripts/python/temp.d/sysApps.txt")
os.system("brew cask list > ${HOME}/scripts/python/temp.d/casks.txt")
    



with open(home + "/scripts/python/temp.d/sysApps.txt", 'rb') as f:
    pl = plistlib.load(f)
    # appname = pl['_name']
    # obtainedfrom = pl['obtained_from']