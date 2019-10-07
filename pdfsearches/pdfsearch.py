#!/usr/bin/env python

import PyPDF2
import re
import os
import time
import argparse

parser = argparse.ArgumentParser(description='Please enter a string to search for.')
parser.add_argument('search_string', help="Your desired search term name.")
args = parser.parse_args()

root = './'

class bcolours:
    BGREEN = '\033[1;38;5;2m'
    BYELLOW = '\033[1;33m'
    BRED = '\033[1;31m'
    BWHITE = '\033[1;38m'
    NORM = '\033[0;38m'

start_time = time.time()
    
search_word = args.search_string
search_word_count = 0
pdf_count = 0

def pdfHasTerm(pdf, term):
    object = PyPDF2.PdfFileReader(pdf, strict=False)

    # get number of pages
    NumPages = object.getNumPages()

    # extract text and do the search
    for i in range(0, NumPages):
        PageObj = object.getPage(i)
        Text = PageObj.extractText() 
        matches = re.search('(?i)' + term, Text)
        if matches:
            return True
    return False

for root, dirs, files in os.walk(root):
    for file in files:
        if file.endswith('.pdf'):
            if pdfHasTerm(os.path.join(root, file), search_word):
                pdfFileObj = open(os.path.join(root, file), 'rb')
                print(bcolours.BWHITE + root, file + bcolours.NORM)

print(bcolours.BYELLOW + "%s seconds" % (time.time() - start_time) + bcolours.NORM)

pdfReader = PyPDF2.PdfFileReader(pdfFileObj, strict=False)

for pageNum in range(1, pdfReader.numPages):
    pageObj = pdfReader.getPage(pageNum)
    text = pageObj.extractText().encode('utf-8')
    search_text = text.lower().split()
    for word in search_text:
        if search_word in word.decode("utf-8"):
            search_word_count += 1
            pdf_count += 1

pdfReader = PyPDF2.PdfFileReader(pdfFileObj, strict=False)

# if you get the UnicodeEncodeError: 'charmap' codec can't encode characters, add .encode("utf-8") to your text
text = pageObj.extractText().encode('utf-8')

print(bcolours.BGREEN + "The word \"{}\" was found {} times in {} pdfs".format(search_word, search_word_count, pdf_count) + bcolours.NORM)