#!/usr/bin/env python

import urllib.request
import urllib.error
import webbrowser
import argparse
import requests
import optparse
import hashlib
import urllib.request as urllib2
from parsel import Selector
from urllib.parse import urlparse
import time
import random
import logging

parser = argparse.ArgumentParser(description='Process string as journal name')
parser.add_argument('journal_name', help="Your desired journal name.")
args = parser.parse_args()

search_term = "TI = (cultur* OR nation* OR ethni* OR race OR societ* OR communit* OR population OR company OR firm OR region* OR intercult* OR civilis* OR global OR countr* OR multination*) AND TI = (universal* OR distance OR compar* OR difference OR similar* OR dimension OR diversi* OR heterogen* OR homogen* OR multiplicity OR varia* OR gap OR span OR separation OR relat* OR amplitude OR size OR common OR ubiquitous OR typical OR consisten* OR magnitude OR proportion OR range OR measure OR analys* OR meta- analysis OR review OR WEIRD* OR psyc*) AND SO=("+args.journal_name.upper()+")"

url_base = "https://apps.webofknowledge.com/WOS_AdvancedSearch_input.do?SID=F2cUpOjmQRdmJHFfVFd&product=WOS&search_mode=AdvancedSearch"

url_adv_search = "https://apps.webofknowledge.com/WOS_CombineSearches.do"

webbrowser.open(url_base) #Opens website

#print urllib.urlopen(url_base).read() #Prints html code of website

print(search_term) #Prints search term

#print(requests.post(url_adv_search, data = adv_search))













'''
start = time.time()


### Crawling to the website

# GET request to WoS adv. search website
response = requests.get(url_adv_search)


## Setup for scrapping tool

# "response.txt" contain all web page content
selector = Selector(response.text)

# Extracting href attribute from anchor tag <a href="*">
href_links = selector.xpath('//a/@href').getall()


#Extracting src attribute from img tag <img src="*">
image_links = selector.xpath('//img/@src').getall()

print('*****************************href_links************************************')
print(href_links)
print('*****************************/href_links************************************')



print('*****************************image_links************************************')
print(image_links)
print('*****************************/image_links************************************')



end = time.time()
print("Time taken in seconds : ", (end-start))
'''