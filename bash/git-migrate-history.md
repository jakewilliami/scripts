### [Method One](https://stackoverflow.com/a/11426261/12069968)

```bash
cd repository
git log --pretty=email --patch-with-stat --reverse --full-index --binary -- path/to/file_or_folder > patch
cd ../another_repository
git am --committer-date-is-author-date < ../repository/patch
```

### [Method Two](http://blog.neutrino.es/2012/git-copy-a-file-or-directory-from-another-repository-preserving-history/)

```bash
cd ~/sourcerepo
export reposrc=myfile.c #or mydir
git format-patch -o /tmp/mergepatchs $(git log $reposrc|grep ^commit|tail -1|awk '{print $2}')^..HEAD $reposrc
cd ~/destrepo
git am --committer-date-is-author-date /tmp/mergepatchs/*.patch
```

### Notes

If you have the error
```
fatal: previous rebase directory .git/rebase-apply still exists but mbox given.
```

A previous mailbox patch you did has failed and has left a bad patch state.  You can abort the previous patch by running

```bash
git am --abort
```
