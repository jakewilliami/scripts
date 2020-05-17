#!/usr/bin/env python

import os
import argparse
import json
import sys


from os import listdir
from os.path import isfile, isdir, join
from pathlib import Path  # for home dir

home = str(Path.home())


parser = argparse.ArgumentParser(description='Please enter a file directory')
parser.add_argument('dir', help="Your desired directory.")
args = parser.parse_args()


with open(home + "/scripts/bash/colours/textcolours.json") as textcolours:
    colour_dict = json.load(textcolours)

    
colourMap = {'.jl': colour_dict["JULIA"],
            '.py': colour_dict["PYTHON"],
            '.java': colour_dict["JAVA"],
            '.rs': colour_dict["RUST"],
            '.sh': colour_dict["SHELL"],
            '.pl': colour_dict["PERL"],
            '.rb': colour_dict["RUBY"],
            '.ex': colour_dict["ELIXIR"],
            '.lisp': colour_dict["LISP"],
            '.clisp': colour_dict["COMMONLISP"],
            '.lua': colour_dict["LUA"],
            '.c': colour_dict["C"],
            '.cpp': colour_dict["CPP"],
            '.R': colour_dict["R"],
            '.json': colour_dict["JAVASCRIPT"],
            '.md': colour_dict["MARKDOWN"],
            '.txt': colour_dict["TEXT"],
            '.tex': colour_dict["TEX"],
            '.sty': colour_dict["TEX"]
            }


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
    for extension in colourMap.keys():
        if file.endswith(extension):
            print('{}{}{}{}'.format('\t' * level, colourMap.get(extension), file, colour_dict["NORM"]))
            return
    print('{}{}{}{}'.format('\t' * level, colour_dict["SHELL"], file, colour_dict["NORM"]))


def print_files(root, files):
    for file in files:
        if file == 'README.md' or file == '.gitignore' or file == '.DS_Store' or file.startswith('dev-') or file == 'textcolours.txt' or file == 'init_notes.md':
            continue
        print_file(file, 1)


def print_dirs(root, dirs):
    for dir in dirs:
        if dir.startswith('.'):
            continue
#        if dir == 'bash':
#            continue
        print('\t{}{}{}/'.format(colour_dict["BBLUE"], dir, colour_dict["NORM"]))
        for root1, dirs1, files1 in walk_level(os.path.join(root, dir), 0):
            for dir1 in dirs1:
                print('\t\t{}{}{}/'.format(colour_dict["BBLUE"], dir1, colour_dict["NORM"]))
                for root2, dirs2, files2 in walk_level(os.path.join(root, dir, dir1), 0):
                    for dir2 in dirs2:
                        print('\t\t\t{}{}{}/'.format(colour_dict["BBLUE"], dir2, colour_dict["NORM"]))
                    for file2 in files2:
                        print_file(file2, 3)
            for file1 in files1:
                if file1 == '.DS_Store' or file1 == 'readme.md' or file1.startswith('dep-') or file1 == 'textcolours.txt' or file1 == '.gitignore' or file1 == 'init_notes.md':
                    continue
                print_file(file1, 2)


def list_files(start_path):
    for root, dirs, files in walk_level(start_path, 0):
        print_dirs(root, dirs)
        print_files(root, files)


list_files(args.dir)
