# Scripts for Bash et al.

While I am beginning to look into different sorts of programming, I want to have as much experience as possible.  Hence, I have created this repository as a kind of playground for various scripts I try to write.  Be warned that not everything in here may be functional.

---

### Executing commands

Once the scripts have been written, you will need to add the script location to your path, and then make it exacutable.  For me, it was enough to add `export PATH=$PATH:/path/to/dir` to my `~/.bash_profile`, and then run that line in the normal terminal and it should be added to your path; check by `echo $PATH`.  Alternatively, for a one-liner:
```
echo 'export PATH="/path/to/dir:$PATH"' >> ~/.bash_profile
```
To make the script executable, simply type (in the directory of your script) `chmod u+x <name_of_script>`, and your script will be executable (from that directory only, until you add it to your path; then it will be executable anywhere).

You only need to do the above for bash scripts (which, for ease of commandifying them, do not have a file extension).  To run julia scripts, type `julia <name_of_script>` in the directory of the script.  Similarly, for python, run `python3 <name_of_script>`; for perl, `perl <name_of_script>`, for ruby, `ruby <name_of_script>`.  You get the idea.

Finally, if a script has a `cd` command in it, to execute the script AND go to that directory specified in the script, you will need to type `. <name_of_script>`.

Happy scripting!

---

### Chromatic Echos

(That sub-heading would be an awesome band name).  For reference, I have:
* bold green = `echo -e "\033[1;38;5;2m <ENTER_TEXT_HERE> \033[0;38m"`
* bold yellow = `echo -e "\033[1;33m <ENTER_TEXT_HERE> \033[0;38m"`
* bold red = `echo -e "\033[01;31m <ENTER_TEXT_HERE> \033[0;38m"`
* bold blue = `echo -e "\033[1;34m <ENTER_TEXT_HERE> \033[0;38m"`
* bold white = `echo -e "\033[1;38m <ENTER_TEXT_HERE> \033[0;38m"`

A side note on colour: I use the terminal theme [Arthur](https://github.com/lysyi3m/macos-terminal-themes).  For information of `ls` colour output, see comments in `./scripts`.

### In Case of Moving Files Around

See commit message `git show ef3086a148b7c3f129213e7b438b70d8ad53379a` for the original notes on this process.  The process of moving files *while retaining their commit history* is as follows:
1. `git filter-branch --tree-filter 'if [ -f <file_to_be_moved> ]; then mkdir <new_dir> && mv <file_to_be_moved> ./<new_dir>/<file_to_be_moved>; fi'`.  Note that this will fail if the `new_dir` already exists.
2. If you are doing this more than once, after each move, you will have to run `git update-ref -d refs/original/refs/heads/master`.
3. Once you are finished moving all of the files you need to move, push by using `git push -f origin master`.

### In Case of Issues

If bash rejects the `\r` characters they can be removed with `sed -i "" $'s/\r$//' ./gradlew`.

See commit `git show e3e79ca03dc16526b486e06b7e88d8db566986e4` in branch `1.14.4` in [this repo](https://github.com/Explosive-Crayons/Electrum) for more on this.
