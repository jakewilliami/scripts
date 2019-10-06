#!/usr/bin/env python

'''import PyPDF2

pdfFileObj = open('/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf', 'rb')
pdfReader = PyPDF2.PdfFileReader(pdfFileObj, strict=False)
search_word = "allport"
search_word_count = 0
for pageNum in range(1, pdfReader.numPages):
    pageObj = pdfReader.getPage(pageNum)
    text = pageObj.extractText().encode('utf-8')
    search_text = text.lower().split()
    for word in search_text:
        if search_word in word.decode("utf-8"):
            search_word_count += 1

# If you get the PdfReadError: Multiple definitions in dictionary at byte, add strict = False
pdfReader = PyPDF2.PdfFileReader(pdfFileObj, strict=False)

# if you get the UnicodeEncodeError: 'charmap' codec can't encode characters, add .encode("utf-8") to your text
text = pageObj.extractText().encode('utf-8')
        
print("The word {} was found {} times".format(search_word, search_word_count))'''


####################################################################

#Early version of code for pdfsearch


import PyPDF2
import re
import os

def pdfHasTerm(pdf, term):
    # open the pdf file
    object = PyPDF2.PdfFileReader(pdf)

    # get number of pages
    NumPages = object.getNumPages()

#    # extract text and do the search
#    for i in range(0, NumPages):
#        PageObj = object.getPage(i)
#        Text = PageObj.extractText() 
#        #print(Text)
#        matches = re.search(term, Text)
#        if matches:
#            print("this is page " + str(i)) 
#            print (matches)
#            return True
#    
#    return False

root = '/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/'
for root, dirs, files in os.walk(root):
    for file in files:
        if file.endswith('.pdf'):
            if pdfHasTerm(os.path.join(root, file), 'allport'):
                print (file)
               

###########################################################################
            
#Had to run (after entering the python3 environment) to get nltk (downloader was broken): 

#import nltk
#import ssl

#try:
#    _create_unverified_https_context = ssl._create_unverified_context
#except AttributeError:
#    pass
#else:
#    ssl._create_default_https_context = _create_unverified_https_context

#nltk.download()

#in the command terminal.  If in doubt, manually add downloaded folders from http://www.nltk.org/nltk_data/ in /usr/local/share/nltk_data/tokenizers

'''
from nltk.data import load
from nltk.tokenize.treebank import TreebankWordTokenizer

sentences = [
    "Mr. Green killed Colonel Mustard in the study with the candlestick. Mr. Green is not a very nice fellow.",
    "Professor Plum has a green plant in his study.",
    "Miss Scarlett watered Professor Plum's green plant while he was away from his office last week."
]

tokenizer = load('/Users/jakeireland/nltk_data/english.pickle')
treebank_word_tokenize = TreebankWordTokenizer().tokenize

wordToken = []
for sent in sentences:
    subSentToken = []
    for subSent in tokenizer.tokenize(sent):
        subSentToken.extend([token for token in treebank_word_tokenize(subSent)])

    wordToken.append(subSentToken)

for token in wordToken:
    print(token)'''