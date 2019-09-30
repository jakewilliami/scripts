import webbrowser
import argparse

parser = argparse.ArgumentParser(description='Process string as language')
parser.add_argument('language', help="Your desired langauge to search by.")
args = parser.parse_args()

url_search = "https://github.com/search?q=language%3A"+args.language+""

webbrowser.open(url_search) #Opens website