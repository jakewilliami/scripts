<h1 align="center">
Scripts for Bash
</h1>


## Description
While I am playing around with programming languages, the one that got me started was Bash.  There is a lot you can do with Bash, and this is my directory for those scripts.

I have added the following to my `~/.bashrc`:
```
alias scripts="source scripts"
```


## Contents
- [Notes on Uncompiled Scripts](#notes-on-uncompiled-scripts)
- [In Case of Issues](#in-case-of-issues)
- [A Note on `cd` in Subshell](#a-note-on-cd-in-subshell)
- [Chromatic Echos](#chromatic-echos)
- [A Note on Executing `clean`](#a-note-on-executing-clean)


---

## Notes on Uncompiled Scripts

Running `gl -l` on my old 2008 iMac required
```
brew install ruby openssl && \curl -sSL https://get.rvm.io | bash -s stable && source ~/.rmv/scripts/rvm && rvm install 2.2.3 --disable-binary && brew install icu4c cmake pkg-config && gem install github-linguist
```
Running `gl -c` on my 2008 iMac required me to have `brew install ghi`, as well as the above.

At present (24.10.2019) I have plans to compile the scripts so that they can be used without these prerequisites (`cd ~/bin/scripts && ghi show 34`).


## In Case of Issues Executing

If bash rejects the `\r` characters they can be removed with `sed -i "" $'s/\r$//' /path/to/file`.

See commit `git show e3e79ca03dc16526b486e06b7e88d8db566986e4` in branch `1.14.4` in [this repo](https://github.com/Explosive-Crayons/Electrum) for more on this.


## A Note on `cd` in Subshell

When you write `cd /path/to/dir` in a script and run it, you don't actually change working directories in your session (only in the subshell running in the script).  An easy workaround is to write
```
. <name_of_script>
```
to actually go to the directory specified in the script.  To make this less annoying, I have added to my `~/.bashrc` the following line:
```
alias <name_of_script>=". <name_of_script>"
```
which will work for the most part.  However, this causes session errors when you have options in your script (if you enter an invalid option, it will close your current session [for](https://stackoverflow.com/questions/32418438/how-can-i-disable-bash-sessions-in-os-x-el-capitan) some [reason](https://www.reddit.com/r/osx/comments/397uep/changes_to_bash_sessions_and_terminal_in_el/)).  To get around this, wherever I have `exit $?` in my scripts, I have `return $?` instead (to stop it from [exiting the shell itself](https://unix.stackexchange.com/questions/138730/exit-the-bash-function-not-the-terminal)).

## Chromatic Echos

(That sub-heading would be an awesome band name).  For reference future reference/interest, I use the terminal theme [Arthur](https://github.com/lysyi3m/macos-terminal-themes).  For information of `ls` colour output, see comments in `./python/ls.py`.

## A Note on Executing `clean`

In the root directory, there exists a trash folder: `/private/var/root/.Trash`.  This is tricky to access in a sub-shell (such as the one created when running `clean --trash`), so I have run the command
```
echo 'alias clean="sudo clean"' >> ~/.bashrc
```
Which allows the user to find and access the root trash directory.
