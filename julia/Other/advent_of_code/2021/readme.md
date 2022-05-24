# Advent of Code, 2021

## Benchmarking Results

I am using [`hyperfine`](https://github.com/sharkdp/hyperfine) to benchmark results.  

### Example

Main command:
```bash
$ hyperfine --warmup=3 -N --export-markdown=benchmark.md day1
```