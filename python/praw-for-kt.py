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


#Print post author
print(bold_lines)
print(bcolours.BBLUE + 'Author' + bcolours.NORM)
print(submission.author)


#Print post subreddit
print(bold_lines)
print(bcolours.BBLUE + 'Subreddit' + bcolours.NORM)
print(submission.subreddit)

#Print post title
print(bold_lines)
print(bcolours.BBLUE + 'Title' + bcolours.NORM)
print(submission.title)


#Prints post body
print(bold_lines)
print(bcolours.BBLUE + 'Post Body' + bcolours.NORM)
print(submission.selftext)

#Print number of upvotes
print(bold_lines)
print(bcolours.BBLUE + 'Number of Upvotes' + bcolours.NORM)
print(submission.score)

#Print number of comments
print(bold_lines)
print(bcolours.BBLUE + 'Number of Comments' + bcolours.NORM)
print(submission.num_comments)

#Print top comment
print(bold_lines)
print(bcolours.BBLUE + 'Top Comment' + bcolours.NORM)
for top_level_comment in submission.comments:
    print(top_level_comment.body)
		
#Post URL
print(bold_lines)
print(bcolours.BBLUE + 'Post URL' + bcolours.NORM)
print(submission.url)




#Gets csv of data from ten hottest posts of subreddit
#posts = []
#ml_subreddit = reddit.subreddit('MachineLearning')
#for post in ml_subreddit.hot(limit=10):
#    posts.append([post.title, post.score, post.id, post.subreddit, post.url, post.num_comments, post.selftext, post.created])
#posts = pd.DataFrame(posts,columns=['title', 'score', 'id', 'subreddit', 'url', 'num_comments', 'body', 'created'])
#print(posts)


