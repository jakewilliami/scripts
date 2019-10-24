<h1 align="center">
Scripts for Bash
</h1>


## Description
While I am playing around with programming languages, the one that got me started was Bash.  There is a lot you can do with Bash, and this is my directory for those scripts.

I have added the following to my `~/.bashrc`:
```
alias scripts="source scripts"
```

## Notes on Uncompiled Scripts

Running `gl -l` requires `brew install ruby openssl && gem install github-linguist`.  Running `gl -c` requires you to have `brew install ghi`.  At present (24.10.2019) I have plans to compile the scripts so that they can be used without these prerequisites (`cd ~/bin/scripts && ghi show 34`).
