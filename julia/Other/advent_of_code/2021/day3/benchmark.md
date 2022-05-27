## Before Bitwise Optimisation (7813c84)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `day3` | 49.9 ± 3.6 | 45.8 | 64.8 | 1.00 |

## After Optimisation (6a82222)

| Command | Mean [ms] | Min [ms] | Max [ms] | Relative |
|:---|---:|---:|---:|---:|
| `day3` | 21.7 ± 3.2 | 18.8 | 35.1 | 1.00 |

## Note

Interestingly, at 84aef4e (which is before any optimisation), the programme ran at around 50 ms.  I optimised the inverstion (i.e., finding the epsilon rate; previous in `invert_bitstring`) in 7813c84 and the benchmark didn't really change very much.  However, optimising finding the bitstring with the most common bits from our input (`find_populist_bitstring_naive` &rarr; `find_populist_bitstring`; in 6a82222) improved the efficiency by more than double.  It's massive!