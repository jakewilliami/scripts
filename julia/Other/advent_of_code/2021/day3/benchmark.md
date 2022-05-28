## Splitting Parts of Problem
| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `./day3` | 5.4 ± 1.4 | 4.0 | 12.5 | 1.00 |
| `./day3 1` | 7.2 ± 1.9 | 5.2 | 19.3 | 1.32 ± 0.49 |
| `./day3 2` | 12.8 ± 2.2 | 9.4 | 20.0 | 2.36 ± 0.74 |

## Prior to Split

### Before Bitwise Optimisation (7813c84)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `day3` | 49.9 ± 3.6 | 45.8 | 64.8 | 1.00 |

### After Optimisation (6a82222)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `day3` | 21.7 ± 3.2 | 18.8 | 35.1 | 1.00 |

### Note on Optimisation

Interestingly, at 84aef4e (which is before any optimisation), the programme ran at around 50 ms.  I optimised the inverstion (i.e., finding the epsilon rate; previous in `invert_bitstring`) in 7813c84 and the benchmark didn't really change very much.  However, optimising finding the bitstring with the most common bits from our input (`find_populist_bitstring_naive` &rarr; `find_populist_bitstring`; in 6a82222) improved the efficiency by more than double.  It's massive!

It is also important to note that `./day3` will run much faster than `day3` as the latter may look at path before current directory.