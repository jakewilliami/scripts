### [Method One](https://stackoverflow.com/a/8083362/12069968)

```bash
git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch path_to_file_or_dir" HEAD
```

### [Method Two](https://github.com/newren/git-filter-repo/)

```bash
brew install git-filter-repo
git filter-repo --invert-paths --path path_to_file_or_dir
```
