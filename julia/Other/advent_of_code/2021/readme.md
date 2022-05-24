# Advent of Code, 2021

## Benchmarking Results

I am using [`hyperfine`](https://github.com/sharkdp/hyperfine) to benchmark results.  

### Example

Main command:
```bash
$ hyperfine --warmup=3 -N --export-markdown=benchmark.md day1
```

You can add multiple executables if you have made them
```bash
$ rustc day1.rs -o day1_rs
$ go build -o day1_go day1.go
$ nim c -o=day1_nim day1.nim
$ hyperfine --warmup=3 -N --export-markdown=benchmark.md day1_rs day1_go day1_nim
```