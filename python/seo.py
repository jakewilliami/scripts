#! /usr/bin/env python3

# https://www.searchenginejournal.com/seo-tasks-automate-with-python/351050/
# https://github.com/sethblack/python-seo-analyzer/

from seoanalyzer import analyze

# output = analyze(site, sitemap)
siteA = "https://www.google.com/"
analysisA = analyze(siteA)

print(analysisA)
