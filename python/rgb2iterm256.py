#! /usr/bin/env python3

import sys
import os
from colormap import rgb2hex

# res = os.system("./hex2iterm256.py {}".format(rgb2hex(SYS.ARGV[1], SYS.ARGV[2], SYS.ARGV[3])))
os.system("./hex2iterm256.py {}".format(rgb2hex(int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]))[1:]))

