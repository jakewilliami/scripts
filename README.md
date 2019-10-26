<h1 align="center">
  Scripts for Bash et al.
</h1>


## Description

While I am beginning to look into different sorts of programming, I want to have as much experience as possible.  Hence, I have created this repository as a kind of playground for various scripts I try to write.  Be warned that not everything in here may be functional.

The present repository is found on my computer in `~/bin/`.  Ensure you make this binary repository before cloning, and clone into it, as some commands will depend on this.  Change these according to your file structure.

## Contents

- [Description](#description)
- [Contents](#contents)
- [Executing Commands](#executing-commands)
- [In Case of Moving Files Around](#in-case-of-moving-files-around)
- [In Case of Finding and Replacing Text Within Files](#in-case-of-finding-and-replacing-text-within-files)

---

## Executing commands

Once the scripts have been written, you will need to add the script location to your path, and then make it exacutable.  The former can be done by:
```
echo 'export PATH=$PATH:/path/to/dir' >> ~/.bash_profile
```
You may need to restart terminal after this step.  To make the script executable, simply type (in the directory of your script) 
```
chmod u+x <name_of_script>`
```
and your script will be executable (from that directory only, until you add it to your path; then it will be executable anywhere).

You only need to do the above for bash scripts (which, for ease of commandifying them, do not have a file extension).  Running other kinds of scripts may have different requirements.

Happy scripting!


## In Case of Moving Files Around

See commit message `git show ef3086a148b7c3f129213e7b438b70d8ad53379a` for the original notes on this process.  The process of moving files *while retaining their commit history* is as follows:
1. `git filter-branch --tree-filter 'if [ -f <file_to_be_moved> ]; then mkdir <new_dir> && mv <file_to_be_moved> ./<new_dir>/<file_to_be_moved>; fi'`.  Note that this will fail if the `new_dir` already exists.
2. If you are doing this more than once, after each move, you will have to run `git update-ref -d refs/original/refs/heads/master`.
3. Once you are finished moving all of the files you need to move, push by using `git push -f origin master`.


## In Case of Finding and Replacing Text Within Files

I have had trouble replicating Unix-based `sed` solutions, so I have used perl:
```
perl -pi -e 's/<term to find>/<term to replace>/g' path/to/file(s)
```
It should be noted that you must escape any special characters with a `\`.
