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

Running `gl -l` on my old 2008 iMac required
```
brew install ruby openssl && \curl -sSL https://get.rvm.io | bash -s stable && source ~/.rmv/scripts/rvm && rvm install 2.2.3 --disable-binary && brew install icu4c cmake pkg-config && gem install github-linguist
```
Running `gl -c` on my 2008 iMac required me to have `brew install ghi`, as well as the above.

At present (24.10.2019) I have plans to compile the scripts so that they can be used without these prerequisites (`cd ~/bin/scripts && ghi show 34`).
