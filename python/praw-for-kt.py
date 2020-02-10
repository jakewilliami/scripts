#! /usr/bin/python


import praw # for pulling from reddit
import time # for interpreting submission time/date
import argparse # for parsing arguments on command line


"""
<username>'s saved comments:
    https://www.reddit.com/user/<username>/saved/
"""


from pathlib import Path  # for home dir


# Set home
home = str(Path.home())


# Define colours
class bcolours:
    BGREEN = '\033[1;38;5;2m'
    BYELLOW = '\033[1;33m'
    BRED = '\033[1;31m'
    BWHITE = '\033[1;38m'
    NORM = '\033[0;38m'
    BBLUE = '\033[1;38;5;26m'   


# define arguments
parser = argparse.ArgumentParser(description=bcolours.BRED + 'Please enter a reddit url.' + bcolours.NORM)
parser.add_argument('search_url', help=bcolours.BYELLOW + "Your desired reddit url." + bcolours.NORM)
args = parser.parse_args() 


# Verifying developer (me!)
reddit = praw.Reddit(client_id='9lJHEJJnukjWow', client_secret='OVA80sjQDi1-jkBxO10JR6drFh0', user_agent='DrDeducer')


# Define delimiter for data array
delim = 4*'='


def submission_data(url_param):
    """
    define function for a *post*.  Outputs (with delimiter defined above):
        "post author, subreddit, post title, post body, submission score, upvote ratio to downvotes,...
        "number of comments, post url, date and time of submission, top-most comment, top most comment's top response"
    """
    # Define post
    submission = reddit.submission(url=url_param)
    # Time def
    submission_time = time.ctime(submission.created_utc)
    # Print top comment
    top_level_reply = ''
    top_level_comment = submission.comments[0]
    # get top comment's top reply
    if len(top_level_comment.replies) > 0:
        top_level_reply = top_level_comment.replies[0].body
    # print string with delimiters
    return submission.author.name + \
        delim + submission.subreddit.display_name + \
        delim + submission.title + \
        delim + submission.selftext + \
        delim + str(submission.score) + \
        delim + str(submission.upvote_ratio) + \
        delim + str(submission.num_comments) + \
        delim + submission.url + \
        delim + submission_time + \
        delim + top_level_comment.body + \
        delim + top_level_reply


def comment_data(url_param):
    """
    define function for a *comment*.  Outputs (with delimiter defined above):
        "comment author, subreddit, parent post title, comment body, comment score, comment url,...
        "date and time of comment, parent comment if available,..."
    """
    # Define comment
    comment = reddit.comment(url=url_param)
    # Define comment's post
    submission = reddit.submission(id=comment.submission)
    # Time def
    submission_time = time.ctime(comment.created_utc)
    # check to see if the comment parent is another comment, and define parent_comment based on that
    parent_comment = ''
    if not comment.parent() == submission.id:
        parent_comment = reddit.comment(id=comment.parent())
    # get comment's top reply
    if len(comment.replies) > 0:
        print(comment.replies.body)
    return comment.author.name + \
        delim + submission.subreddit.display_name + \
        delim + submission.title + \
        delim + comment.body + \
        delim + str(comment.score) + \
        delim + comment.permalink + \
        delim + submission_time + \
        (delim + parent_comment.body if not comment.parent() == submission.id else '')


# Create text file
archive_file = open(home + "/scripts/python/temp.d/reddit-archive-to-be-read.txt", "w")
# write submission to file
# archive_file.write(submission_data(args.search_url))
archive_file.write(comment_data(args.search_url))
# stop writing to file
archive_file.close()


def generate_pdf(filename,destination=""):
    """
    Genertates the pdf from string using LaTeX
    """
    import subprocess
    import shutil
    import subprocess
    import os
    import tempfile
    import shutil
    current = os.getcwd()
    temp = tempfile.mkdtemp()
    os.chdir(temp)
    f = open('cover.tex', 'w')
    f.write(tex)
    f.close()
    proc = subprocess.Popen(['pdflatex', 'cover.tex'])
    subprocess.Popen(['pdflatex', tex])
    proc.communicate()

    os.rename('cover.pdf', pdfname)
    shutil.copy(pdfname, current)
    shutil.rmtree(temp)


