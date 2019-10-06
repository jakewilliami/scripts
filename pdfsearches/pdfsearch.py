#!/usr/bin/env python

import PyPDF2
import re

# open the pdf file
object = PyPDF2.PdfFileReader("/Users/jakeireland/Desktop/Study/Victoria University/2018/Trimester 2/PSYC221/Minority Report/Report/Minority Report.pdf")

# get number of pages
NumPages = object.getNumPages()

# define keyterms
String = "Allport"

# extract text and do the search
for i in range(0, NumPages):
    PageObj = object.getPage(i)
    print("this is page " + str(i)) 
    Text = PageObj.extractText() 
    # print(Text)
    ResSearch = re.search(String, Text)
    print(ResSearch)