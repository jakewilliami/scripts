import praw
import pandas as pd
import subprocess


#Define colours
class bcolours:
    BGREEN = '\033[1;38;5;2m'
    BYELLOW = '\033[1;33m'
    BRED = '\033[1;31m'
    BWHITE = '\033[1;38m'
    NORM = '\033[0;38m'
    BBLUE = '\033[1;38;5;26m'


#Get terminal width
rows, columns = subprocess.check_output(['stty', 'size']).decode().split()
term_cols = int(columns)


#Verifying developer
reddit = praw.Reddit(client_id='9lJHEJJnukjWow', client_secret='OVA80sjQDi1-jkBxO10JR6drFh0', user_agent='DrDeducer')



#Define post
submission = reddit.submission(id='9fbxri')


#Define bolded equals (double white lines)
bold_lines = bcolours.BWHITE + '=' * term_cols + bcolours.NORM


#reddit_author = submission.author
#reddit_sub = submission.subreddit
#reddit_title = submission.title
#reddit_body = submission.selftext
#reddit_upvotes = submission.score
#reddit_comments = submission.num_comments
#
#reddit_link = submission.url


##Print top comment
#for top_level_comment in submission.comments:
#    print(top_level_comment.body)

data_array = []

data_array = [submission.author,
              submission.subreddit,
              submission.title,
              submission.selftext,
              submission.score,
              submission.num_comments,
              submission.url]

delim = '==='

print(data_array)

#str = delim.join(data_array)
#print(data_array)




#Gets csv of data from ten hottest posts of subreddit
#posts = []
#ml_subreddit = reddit.subreddit('MachineLearning')
#for post in ml_subreddit.hot(limit=10):
#    posts.append([post.title, post.score, post.id, post.subreddit, post.url, post.num_comments, post.selftext, post.created])
#posts = pd.DataFrame(posts,columns=['title', 'score', 'id', 'subreddit', 'url', 'num_comments', 'body', 'created'])
#print(posts)


