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

You can also programmatically find their colours, as I rewrote the above python script in Julia:
```bash
curl https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml > languages.yml; julia -E 'import Pkg; Pkg.add.(["YAML", "OrderedCollections", "Colors"]); using YAML; include("$(homedir())/projects/scripts/python/rgb2iterm256.jl"); f = YAML.load_file("languages.yml"); for k in keys(f); col = get(f[k], "color", ""); if !isempty(col); print(k, ":\t\t"); main(col); end; end'; rm languages.yml
```
Or if you already have `YAML`, `OrderedCollections`, or `Colors` installed via `Julia`, simply run
```bash
curl https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml > languages.yml; julia -E 'using YAML; include("$(homedir())/projects/scripts/python/rgb2iterm256.jl"); f = YAML.load_file("languages.yml"); for k in keys(f); col = get(f[k], "color", ""); if !isempty(col); print(k, ":\t\t"); main(col); end; end'; rm languages.yml
```