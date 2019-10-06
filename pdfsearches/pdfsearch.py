#!/usr/bin/env python

import PyPDF2
import re
import os

def pdfHasTerm(pdf, term):                
    # open the pdf file
    object = PyPDF2.PdfFileReader(pdf)

    # get number of pages
    NumPages = object.getNumPages()

    # extract text and do the search
    for i in range(0, NumPages):
        PageObj = object.getPage(i)
        Text = PageObj.extractText() 
        #print(Text)
        matches = re.search(term, Text)
        if matches:
            print("this is page " + str(i)) 
            print (matches)
            return True
    
    return False

root = '/Users/jakeireland/Desktop/Study'
for root, dirs, files in os.walk(root):
    for file in files:
        if file.endswith('.pdf'):
            if pdfHasTerm(os.path.join(root, file), 'allport'):
                print (file)

#import scraperwiki, urllib2
#from bs4 import BeautifulSoup
#
#def send_Request(url):
##Get content, regardless of whether an HTML, XML or PDF file
#    pageContent = urllib2.urlopen(url)
#    return pageContent
#
#def process_PDF(fileLocation):
##Use this to get PDF, covert to XML
#    pdfToProcess = send_Request(fileLocation)
#    pdfToObject = scraperwiki.pdftoxml(pdfToProcess.read())
#    return pdfToObject
#
#def parse_HTML_tree(contentToParse):
##returns a navigatibale tree, which you can iterate through
#    soup = BeautifulSoup(contentToParse)
#    return soup
#
#pdf = process_PDF('http://greenteapress.com/thinkstats/thinkstats.pdf')
#pdfToSoup = parse_HTML_tree(pdf)
#soupToArray = pdfToSoup.findAll('text')
#for line in soupToArray:
#    print(line)