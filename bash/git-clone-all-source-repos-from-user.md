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

