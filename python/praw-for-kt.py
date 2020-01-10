import praw
import pandas as pd
import subprocess
import time
import argparse


from pathlib import Path  # for home dir


# Set home
home = str(Path.home())


#Define colours
class bcolours:
    BGREEN = '\033[1;38;5;2m'
    BYELLOW = '\033[1;33m'
    BRED = '\033[1;31m'
    BWHITE = '\033[1;38m'
    NORM = '\033[0;38m'
    BBLUE = '\033[1;38;5;26m'
    
    
    
parser = argparse.ArgumentParser(description=bcolours.BRED + 'Please enter a reddit url.' + bcolours.NORM)
parser.add_argument('search_url', help=bcolours.BYELLOW + "Your desired reddit url." + bcolours.NORM)
args = parser.parse_args() 


#Verifying developer
reddit = praw.Reddit(client_id='9lJHEJJnukjWow', client_secret='OVA80sjQDi1-jkBxO10JR6drFh0', user_agent='DrDeducer')



#Define post
submission = reddit.submission(url=args.search_url)


##Print top comment
comment_array = []
for top_level_comment in submission.comments:
    comment_array.append(top_level_comment.body)
    
    
#Time def
submission_time = time.ctime(submission.created_utc)

#Def data array
data_array = [submission.author.name,
              submission.subreddit.display_name,
              submission.title,
              submission.selftext,
              str(submission.score),
              str(submission.num_comments),
              submission.url,
              submission_time]


new_array = data_array + comment_array

delim = '===='

#print(submission_time)


#Make data array str delimited
str_delim = delim.join(data_array)


#Create text file
archive_file = open(home + "/scripts/python/reddit-archive-to-be-read.txt", "w")
archive_file.write(str_delim)
archive_file.close()


