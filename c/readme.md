This is my C directory, while I learn C.

To compile a project
```
gcc <file.c>
```

I will also be using this directory for C++.
For this, you will need to run
```
brew install qt
brew link qt --force
cd ~/scripts/c/tm/; qmake -makefile; make
```

For adding new language headers to `ls.c` file, simply run

```bash
julia -E 'import Pkg; Pkg.add.(["LazyJSON", "Printf"]); using LazyJSON; using Printf; for (n, m) in LazyJSON.parse(read("$(homedir())/projects/scripts/bash/colours/textcolours.json", String)); @printf("%-23s%s%s%s\n", "#define $(strip(n))", "\"", strip(escape_string(m)), "\""); end'
```
