# Benchmarking Results (Julia)

Day | Time | Memory | Allocations | Name
--- | --- | --- | --- | ---
1.1 | 1.614 ms | 306.53 KiB | 18724 | Report Repair
1.2 | 1.425 s | 289.41 MiB | 18966025 | Report Repair
2.1 | 9.293 ms | 2.36 MiB | 66697 | Password Philosophy
2.2 | 7.863 ms | 2.11 MiB | 53354 | Password Philosophy
3.1 | 317.878 μs | 486.55 KiB | 1969 | Toboggan Trajectory
3.2 | 1.886 ms | 2.70 MiB | 9280 | Toboggan Trajectory
4.1 | 2.007 ms | 550.70 KiB | 8833 | Passport Processing
4.2 | 2.402 ms | 710.09 KiB | 11345 | Passport Processing
5.1 | 217.239 μs | 74.88 KiB | 1657 | Binary Boarding
5.2 | 355.110 μs | 74.88 KiB | 1657 | Binary Boarding
6.1 | 1.303 ms | 1.03 MiB | 12149 | Custom Customs
6.2 | 1.843 ms | 1.18 MiB | 15400 | Custom Customs
7.1 | 190.356 ms | 151.30 MiB | 2908237 | Handy Haversacks
7.2 | 13.236 ms | 4.86 MiB | 114871 | Handy Haversacks
8.1 | 49.615 ms | 29.85 MiB | 58606 | Handheld Halting
8.2 | 99.045 ms | 47.14 MiB | 477655 | Handheld Halting
9.1 | 166.677 μs | 23.00 KiB | 661 | Encoding Error
9.2 | 352.691 ms | 1.16 GiB | 388972 | Encoding Error
10.1 | 977.456 μs | 293.77 KiB | 4033 | Adapter Array
10.2 | 37.124 μs | 13.80 KiB | 245 | Adapter Array
11.1 | 17.815 s | 6.60 GiB | 145121722 | Seating System
11.2 | 22.063 s | 8.43 GiB | 187101585 | Seating System
12.1 | 11.641 ms | 7.33 MiB | 52689 | Rain Risk
12.2 | 10.706 ms | 7.33 MiB | 52957 | Rain Risk
13.1 | 121.051 μs | 68.44 KiB | 521 | Shuttle Search
13.2 | 146.392 μs | 77.81 KiB | 745 | Shuttle Search

---

# Notes

### System Information

```julia
julia> versioninfo()
Julia Version 1.5.3
Commit 788b2c77c1 (2020-11-09 13:37 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin18.7.0)
  CPU: Intel(R) Core(TM) i5-6360U CPU @ 2.00GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-9.0.1 (ORCJIT, skylake)
```

### Day 1

I only did this naïvely, using nested for loops.

### Day 3

Okay, so some clever people just took the modulus of the index because the map wraps around itself.  However, I physically extended the map when needed.  Yes, it makes it a little slow &mdash; uses more memory &mdash; but add a print statement somewhere and you get a nice visualisation!

### Day 11

The reason this takes so long is because I made this work for n-dimensional seating arrangements (untested because representation of n dimensions in a text file is somewhat tricky).

### Day 13

The naïve approach to part 2 took a long time:
```julia
$ julia --threads=5

julia> @btime find_timestamp_brute_force(parse_input(datafile));

julia> versioninfo()
Julia Version 1.5.1
Commit 697e782ab8 (2020-08-25 20:08 UTC)
Platform Info:
  OS: Linux (x86_64-pc-linux-gnu)
  CPU: Intel(R) Xeon(R) CPU E5-2683 v4 @ 2.10GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-9.0.1 (ORCJIT, broadwell)
```

### Day 14

I found this one very difficult.  I usually get stuck on the recursive ones (namely, 7.2 and 10.2, for which I got advice from dmipeck and rmsrosa respectively), but this one was much worse for me, conceptually, as I haven't worked much with bits and any non-decimal numbers.  dmipeck helped me to understand the problem.
