# Command-Line Tools

This is a file to explain commonly-used command-line tools within my workflow.

## Essential

### [`git`](https://git.kernel.org/pub/scm/git/git.git)
If you are reading this on GitHub, then you shouldn't be suprised that `git` is likely the most essential tool in my toolkit/workflows.

### [`emacs`](https://git.savannah.gnu.org/git/emacs.git/)
Emacs is my editor of choice.  I should probably get more familiar with `vi`, as it's on just about every system by default, but I like the power of Emacs.

### [`tmux`](https://github.com/tmux/tmux)
Similar to `screen`, `tmux` is a way to manage multiple terminal sessions without having to create new tabs.  It is detachable, so is very convenient when working on many projects (which I do a lot).

## Quality-of-Life

### [`gl`](https://github.com/jakewilliami/gl)
Instead of using git aliases, when I first began programming, I wanted to pretty-print my git log, in such a way that bolded authors that weren't me.  In that sense, [it started off relatively simple](https://github.com/jakewilliami/scripts/blob/98a327a088bc132e4418e3010b228e5f42ffff9c/bash/gl).  Since then I have extended the functionality of it, adding various git-related flags to it.  I use it often enough to have ported over to a Rust project, which then became it's own repository.

### [`fd`/`fdfind`](https://github.com/sharkdp/fd)
A fast and modern alternative to `find`, written in Rust.

### [`exa`](https://github.com/ogham/exa)
A fast and modern alternative to `ls`, written in Rust.

### [`rg`](https://github.com/BurntSushi/ripgrep)
A fast and modern alternative to `grep -r`, written in Rust.

### [`hyperfine`](https://github.com/sharkdp/hyperfine)
A benchmarking tool for comparing efficiency of binaries.  See references to the tool [here](./readme.md) and [here](../julia/Other/advent_of_code/2021/readme.md).