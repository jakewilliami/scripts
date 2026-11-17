# Clone All Source Repos From User

I am relatively often required to clone all of a user's or organisation's projects.  This question is answered [here](https://stackoverflow.com/a/68770988).

### Bash

```bash
user="<user>"
gh repo list "$user" --limit 4000 --source | while IFS= read -r repo _; do
    echo gh repo clone "$repo" "$repo"  # remove echo after dry run
done
```

### Fish

```fish
set user "<user>"
for repo in (gh repo list "$user" --limit 4000 --source --json nameWithOwner --jq '.[].nameWithOwner')
    echo gh repo clone "$repo" "$repo"  # remove echo after dry run
end
```

### List Author Emails

Mostly I do this for OSINT reasons, so you can use this (dependencies: [fd](https://github.com/jakewilliami/configs/blob/c66ea4bc854f3dd8b143e012e31fb394b67eaf01/command-line-tools.md#fdfdfind), [gl](https://github.com/jakewilliami/configs/blob/c66ea4bc854f3dd8b143e012e31fb394b67eaf01/command-line-tools.md#gl)):

```fish
cd "$user"
for repo in (fd -t d -d 1)
    cd "$repo"
    echo "===== $repo ====="
    gl -A
    cd - > /dev/null
end
```

# Clone All Repos In User's Collaboration History

Sometimes the target user does not have many or any of their own repositories, but has collaborated in some others' repositories.  In this case, we should clone all of the repos that they might have collaborated in.

### Bash

```bash
user="<user>"
for year in $(seq 2008 $(date +%Y)); do
    gh api graphql \
        -f login="$user" \
        -f from="$year-01-01T00:00:00Z" \
        -f to="$year-12-31T23:59:59Z" \
        -f query='query($login:String!, $from:DateTime!, $to:DateTime!) {
  user(login:$login) {
    contributionsCollection(from:$from, to:$to) {
      commitContributionsByRepository(maxRepositories:100)       { repository { nameWithOwner } }
      pullRequestContributionsByRepository(maxRepositories:100) { repository { nameWithOwner } }
      issueContributionsByRepository(maxRepositories:100)       { repository { nameWithOwner } }
    }
  }
}' --jq '.data.user.contributionsCollection[][] | .repository.nameWithOwner'
done | sort -u | while IFS= read -r repo; do
    gh repo clone "$repo" "$user/$repo"
done
```

### Fish

```fish
set user "<user>"
for year in (seq 2008 (date +%Y))
    gh api graphql \
        -f login="$user" \
        -f from="$year-01-01T00:00:00Z" \
        -f to="$year-12-31T23:59:59Z" \
        -f query='query($login:String!, $from:DateTime!, $to:DateTime!) {
  user(login:$login) {
    contributionsCollection(from:$from, to:$to) {
      commitContributionsByRepository(maxRepositories:100)       { repository { nameWithOwner } }
      pullRequestContributionsByRepository(maxRepositories:100) { repository { nameWithOwner } }
      issueContributionsByRepository(maxRepositories:100)       { repository { nameWithOwner } }
    }
  }
}' --jq '.data.user.contributionsCollection[][] | .repository.nameWithOwner'
end | sort -u | while read -l repo
    echo gh repo clone "$repo" "$user/$repo"
end
```

### List Author Emails

```fish
cd "$user"
for repo in (fd -t d --exact-depth 2)
    cd "$repo"
    echo "===== $repo ====="
    gl -A
    cd - > /dev/null
end
```
