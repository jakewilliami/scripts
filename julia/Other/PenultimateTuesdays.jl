using Dates

_daysinmonth(m::Month, y::Year) = daysinmonth(y.value, m.value)

#= # Old implementation
findfirst_tuesday(m::Month, y::Year) = 
    findfirst(i -> dayofweek(Date(Day(i), m, y)) == Tuesday, 1:_daysinmonth(m, y))
findfirst_tuesday(d::Date) = findfirst_tuesday(Month(d), Year(d))
=#

function findfirst_tuesday(d::Date)
    fd = dayofweek(firstdayofmonth(d))
    return Tuesday - fd + 1 + 7(fd > Tuesday)
end
findfirst_tuesday(m::Month, y::Year) = findfirst_tuesday(Date(m, y))

#= # Old implementation
function penultimate_tuesday_date(m::Month, y::Year)
    ft = findfirst_tuesday(m, y)  # first Tuesday
    d = Date(Day(ft), m, y)
    n_tuesdays = daysofweekinmonth(d)
    tuesdays = ft:7:_daysinmonth(m, y)
    i = findfirst(x -> (n_tuesdays - dayofweekofmonth(Date(Day(x), m, y))) == 1, tuesdays)
    isnothing(i) && return nothing
    pt = Day(tuesdays[i])  # penultimate Tuesday
    return Date(pt, m, y)
end
penultimate_tuesday_date(d::Date) = penultimate_tuesday_date(Month(d), Year(d))
=#

function penultimate_tuesday_date(m::Month, y::Year)
    ft = findfirst_tuesday(m, y)  # first Tuesday
    d = Date(Day(ft), m, y)
    n_tuesdays = daysofweekinmonth(d)
    pt = Day(ft + 7(n_tuesdays - 2))  # penultimate Tuesday
    return Date(pt, m, y)
end
penultimate_tuesday_date(d::Date) = penultimate_tuesday_date(Month(d), Year(d))

#=
julia> @benchmark penultimate_tuesday_date($d)  # OLD IMPLEMENTATION USING FINDFIRST FUNCTIONS
BenchmarkTools.Trial: 10000 samples with 10 evaluations.
 Range (min … max):  1.274 μs … 202.258 μs  ┊ GC (min … max): 0.00% … 98.71%
 Time  (median):     1.429 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.802 μs ±   3.799 μs  ┊ GC (mean ± σ):  2.19% ±  1.40%

  ▇█▆▃▁   ▁▁▂▃▃▂▁▁                                            ▂
  ██████████████████▇█▇▇▆▆▇▆▆▆▆▅▆▅▆▅▅▆▆▅▄▄▄▃▅▅▄▄▄▅▃▅▅▃▃▅▄▄▁▁▄ █
  1.27 μs      Histogram: log(frequency) by time      6.86 μs <

 Memory estimate: 1.12 KiB, allocs estimate: 48.

julia> @benchmark penultimate_tuesday_date2($d)  # NEW IMPLEMENTATION USING PURELY ARITHMETIC
BenchmarkTools.Trial: 10000 samples with 233 evaluations.
 Range (min … max):  320.498 ns …  27.389 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     329.562 ns               ┊ GC (median):    0.00%
 Time  (mean ± σ):   400.002 ns ± 555.542 ns  ┊ GC (mean ± σ):  2.84% ± 3.32%

  █▄▅▃▂▂▃▂▁▁     ▁     ▁▁                                       ▁
  ██████████████████████████▇▇█▇▆▇▆▆▇▆▆▆▆▆▆▆▅▆▅▅▄▅▅▅▅▄▄▅▁▅▅▅▅▄▃ █
  320 ns        Histogram: log(frequency) by time       1.03 μs <

 Memory estimate: 240 bytes, allocs estimate: 10.
=#

