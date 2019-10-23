<h1 align="center">
Scripts for Searching PDFs by String
</h1>


## Description
In my coding adventures, I am trialling out different languages and getting a feel of their syntax through a simple task: making a PDF-searching tool.  I admit, not all of these languages will be best used for this tool (which is why I am timing them, and comparing their times).  It is just a fun little thing.  My first was in Bash, using the tool that already existed called `pdfgrep`.

I have added the following to my `~/.bashrc`:
```
alias pdfsearch.rb="ruby ~/bin/scripts/pdfsearches/pdfsearch.rb"
alias pdfsearch.py="python3 ~/bin/scripts/pdfsearches/pdfsearch.py"
alias pdfsearch.pl="perl -X ~/bin/scripts/pdfsearches/pdfsearch.pl"
alias pdfsearch.lisp="clisp ~/bin/scripts/pdfsearches/pdfsearch.lisp"
```
