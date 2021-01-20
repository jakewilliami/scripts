What I do is

```bash
DAY="1" # day number
touch "$DAY"a; touch "$DAY"b
emacs "$DAY"a # write some code
rustc "$DAY"a && ./"$DAY"a
```

See also an alternative: https://github.com/gobanos/cargo-aoc/blob/master/README.md