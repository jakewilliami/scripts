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

parser = argparse.ArgumentParser(description='Process string as language')
parser.add_argument('language', help="Your desired langauge to search by.")
args = parser.parse_args()

url_search = "https://github.com/search?q=language%3A"+args.language+""

webbrowser.open(url_search) #Opens website