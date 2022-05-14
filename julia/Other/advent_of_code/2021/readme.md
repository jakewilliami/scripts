# Advent of Code, 2021

## Benchmarking Results

I am using [`hyperfine`](https://github.com/sharkdp/hyperfine) to benchmark results.  

### Example

Main command:
```bash
$ hyperfine --warmup=3 -N --export-markdown=benchmark.md ./day1
```

However, I have adapted some of these to use simple subcommands for parts 1 and 2, so that we can benchmark the baseline and then each part:
```bash
$ hyperfine --warmup=100 -N --export-markdown=benchmark.md "./day2" "./day2 1" "./day2 2"
```

Note that we explicitly put `./dayn` rather than `dayn` as it is considerably faster for the command not to be searched in the path, but rather to be absolute.

Also note that some scripts have tests, so you can run these tests via
```bash
$ rustc --test dayn.rs && ./dayn
```

## Profiling

```bash
$ perf record --call-graph dwarf -p $(pgrep <pname>)
$ perf script | inferno-collapse-perf | inferno-flamegraph > perf.svg
```