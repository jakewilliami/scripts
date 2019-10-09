import os
import argparse

from os import listdir
from os.path import isfile, isdir, join

parser = argparse.ArgumentParser(description='Please enter a file directory')
parser.add_argument('dir', help="Your desired directory.")
args = parser.parse_args()


class BColours:
    BGREEN = '\033[1;38;5;2m'
    BYELLOW = '\033[1;33m'
    BRED = '\033[1;31m'
    BWHITE = '\033[1;38m'
    BBLUE = '\033[1;34m'
    NORM = '\033[0;38m'


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


def list_files(start_path):
    for root, dirs, files in walk_level(start_path, 1):
        level = root.replace(start_path, '').count(os.sep)
        indent = ' ' * 8 * level
        if os.path.basename(root) == 'README.md':
            continue
        elif os.path.basename(root).startswith('.'):
            if not os.path.basename(root) == '.':
                continue
        elif isdir(os.path.basename(root)):
            print(BColours.BBLUE + '{}{}/'.format(indent, os.path.basename(root)) + BColours.NORM)
        elif isfile(os.path.basename(root)):
            print(BColours.BRED + '{}{}/'.format(indent, os.path.basename(root)) + BColours.NORM)
        sub_indent = ' ' * 8 * (level + 1)
        root_dir = args.dir
        sub_dirs = [join(root_dir, dir) for dir in listdir(root_dir) if isdir(join(root_dir, dir))]
        for subdir in sub_dirs:
            sub_sub_stuff = [join(subdir, dir) for dir in listdir(subdir) if subdir == subdir]
            for subsubstuff in sub_sub_stuff:
                if subsubstuff.find(subdir):
                    print(BColours.BBLUE + '{}{}'.format(sub_indent, subsubstuff) + BColours.NORM)


list_files(args.dir)
