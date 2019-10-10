import os
import argparse
import string

# import pandas as pd
# import texttable as tt

from os import listdir
from os.path import isfile, isdir, join

parser = argparse.ArgumentParser(description='Please enter a file directory')
parser.add_argument('dir', help="Your desired directory.")
args = parser.parse_args()

BGREEN = '\033[1;38;5;2m'
BYELLOW = '\033[1;33m'
BRED = '\033[1;31m'
BWHITE = '\033[1;38m'
BBLUE = '\033[1;34m'
NORM = '\033[0;38m'
JULIA = '\033[1;38;5;213m'  # '\033[1;38;5;128m'
PYTHON = '\033[1;38;5;18m'
JAVA = '\033[1;38;5;94m'
RUST = '\033[1;38;5;5m'
SHELL = '\033[1;38;5;28m'  # '\033[1;38;5;46m'
PERL = '\033[1;38;5;111m'  # '\033[1;38;5;39m'
RUBY = '\033[1;38;5;88m'

colorMap = {'.jl': JULIA,
            '.py': PYTHON,
            '.java': JAVA,
            '.rs': RUST,
            '.sh': SHELL,
            '.pl': PERL,
            '.rb': RUBY}

'''
for file in os.listdir(args.dir):
    if file == "README.md":
        continue
    elif os.path.isdir(file):
        print(BColours.BRED + file + BColours.NORM)
    elif os.path.isfile(file):
        print(BColours.BBLUE + file + BColours.NORM)'''


def walk_level(some_dir, level=1):
    some_dir = some_dir.rstrip(os.path.sep)
    assert os.path.isdir(some_dir)
    num_sep = some_dir.count(os.path.sep)
    for root, dirs, files in os.walk(some_dir):
        yield root, dirs, files
        num_sep_this = root.count(os.path.sep)
        if num_sep + level <= num_sep_this:
            del dirs[:]


def print_file(file, level):
    for extension in colorMap.keys():
        if file.endswith(extension):
            print('{}{}{}{}'.format('\t' * level, colorMap.get(extension), file, NORM))
            return
    print('{}{}{}{}'.format('\t' * level, SHELL, file, NORM))


def print_dirs(root, dirs):
    for dir in dirs:
        if dir.startswith('.'):
            continue
        print('\t{}{}{}/'.format(BBLUE, dir, NORM))
        for root1, dirs1, files1 in walk_level(os.path.join(root, dir), 0):
            for child in dirs1:
                print_file(child, 2)
            for child in files1:
                print_file(child, 2)


def print_files(root, files):
    for file in files:
        if file == 'README.md' or file == '.gitignore':
            continue
        print_file(file, 1)


def list_files(start_path):
    for root, dirs, files in walk_level(start_path, 0):
        print_dirs(root, dirs)
        print_files(root, files)


list_files(args.dir)
