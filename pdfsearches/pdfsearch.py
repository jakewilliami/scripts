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
    local_word_count = 0
    objectPDF = PyPDF2.PdfFileReader(pdf, strict=False)

    # get number of pages
    NumPages = objectPDF.getNumPages()

    # extract text and do the search
    for i in range(0, NumPages):
        PageObj = objectPDF.getPage(i)
        Text = PageObj.extractText() 
        matches = re.search('(?i)' + term, Text)
        if matches:
            #print(matches)
            local_word_count += 1 
    return local_word_count

for root, dirs, files in os.walk(root):
    for file in files:
        if file.endswith('.pdf'):
            try:
                results = pdfHasTerm(os.path.join(root, file), search_word)
                if results > 0:
                    search_word_count += results
                    pdfFileObj = open(os.path.join(root, file), 'rb')
                    print(bcolours.BWHITE + os.path.join(root, file) + bcolours.NORM)
                    pdf_count += 1
                    pdfFileObj.close()
            except:
                print("ERROR")

print(bcolours.BYELLOW + "%s seconds" % (time.time() - start_time) + bcolours.NORM)

print(bcolours.BGREEN + "The word \"{}\" was found {} times in {} pdfs".format(search_word, search_word_count, pdf_count) + bcolours.NORM)