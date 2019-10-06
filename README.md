# Scripts for Bash et al.

While I am beginning to look into different sorts of programming, I want to have as much experience as possible.  Hence, I have created this repository as a kind of playground for various scripts I try to write.  Be warned that not everything in here may be functional.

---

### Executing commands

Once the scripts have been written, you will need to add the script location to your path (this is a trivial think in the *nix world, so look it up if you don't know how; it varies from system to system but you only have to do it once), and then make it exacutable.  To do the latter, simply type (in the directory of your script) `chmod u+x <name_of_script>`, and your script will be executable (from that directory only, until you add it to your path; then it will be executable anywhere).

You only need to do the above for bash scripts (which, for ease of commandifying them, do not have a file extension).  To run julia scripts, type `julia <name_of_script>` in the directory of the script.  Similarly, for python, run `python3 <name_of_script>`; for perl, `perl <name_of_script>`, for ruby, `ruby <name_of_script>`.  You get the idea.

Happy scripting!

---

### Chromatic Echos

(That sub-heading would be an awesome band name).  For reference, I have:

bold green = `echo -e "\033[1;38;5;2m <  ENTER_TEXT_HERE > \033[0;38m"`

bold yellow = `echo -e "\033[1;33m <  ENTER_TEXT_HERE > \033[0;38m"`

bold red = `echo -e "\033[01;31m <  ENTER_TEXT_HERE > \033[0;38m"`
