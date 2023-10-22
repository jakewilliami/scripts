## Historical Tagging

Sometimes I am required to make some tags historically.  Here is the process:
```bash
$ git checkout <commit hash>  # This is the target commit you want to tag at

$ GIT_COMMITTER_DATE="$(git show --format=%aD | head -1)" git tag -a v2.2.0 -m "What changed! v2.2.0"  # https://stackoverflow.com/a/21759466

$ git push origin v2.2.0 # https://stackoverflow.com/a/5195913
```
