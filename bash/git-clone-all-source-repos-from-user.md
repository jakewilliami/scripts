I am relatively often required to clone all of a user's or organisation's projects.  This question is answered [here](https://stackoverflow.com/a/68770988).

```bash
gh repo list <user> --limit 4000 --source | while IFS= read -r repo _; do
    echo gh repo clone "$repo" "$repo"  # remove echo after dry run
done
```

```fish
for repo in (gh repo list <user> --limit 4000 --source --json nameWithOwner --jq '.[].nameWithOwner')
    echo gh repo clone "$repo" "$repo"  # remove echo after dry run
end
```

---

Mostly I do this for OSINT reasons, so you can use this (dependencies: [fd](https://github.com/jakewilliami/configs/blob/c66ea4bc854f3dd8b143e012e31fb394b67eaf01/command-line-tools.md#fdfdfind), [gl](https://github.com/jakewilliami/configs/blob/c66ea4bc854f3dd8b143e012e31fb394b67eaf01/command-line-tools.md#gl)):

```fish
for repo in (fd -t d -d 1)
    cd "$repo"
    echo "===== $repo ====="
    gl -A
    cd - > /dev/null
end
```

