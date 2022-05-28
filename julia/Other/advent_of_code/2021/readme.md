# Advent of Code, 2021

## Benchmarking Results

I am using [`hyperfine`](https://github.com/sharkdp/hyperfine) to benchmark results.  

### Example

Main command:
```bash
$ hyperfine --warmup=3 -N --export-markdown=benchmark.md ./day1
```

However, I have adapted some of these to use simple command line arguments for parts 1 and 2, so that we can benchmark the baseline and then each part:
```bash
$ hyperfine --warmup=100 -N --export-markdown=benchmark.md "./day2" "./day2 1" "./day2 2"
```