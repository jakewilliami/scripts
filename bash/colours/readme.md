`textcolours_old.json` is the old text colours file, which I found from finding the RGB from an analysis tool, from GitHub, and comparing them with the output of 
```bash
for colour in {1..225}; do echo -en "\033[38;5;${colour}m38;5;${colour} \n"; done | column -x
```

However, if you have a R B G tuple, you can now run
```bash
./rgb2iterm256.py R G B
```
and it will programmatically tell you the best solution.  That is why I changed it.

There are some exceptions though:
  - Programmatically, `PYTHON` should be `61` but I changed it to `26`;
  - Programmatically, `TEX` should be `58` but I changed it to `22`;
  - Programmatically, `YACC` and `CUDA` should both be `59` but I changed them to `107` and `101` respectively;
  - I somehow made a colour for `SMPL` but cannot find that colour on GitHub any longer, so I am keeping the old one.