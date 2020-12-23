using DelimitedFiles: readdlm

const datafile = joinpath(@__DIR__, "inputs", "data15.txt")

function parse_input(datafile::String)
    return vec(readdlm(datafile, ',', Int))
end

"""
This is a naïve approach.
"""
function nthnumberspoken(n::Int, starting_numbers::Vector{Int})
    turn_number, spoken_before = length(starting_numbers), copy(starting_numbers)
    n ≤ length(starting_numbers) && return starting_numbers[n]
    
    while true
        turn_number += 1
        last_spoken = last(spoken_before)
        
        if isone(count(isequal(last_spoken), spoken_before))
            push!(spoken_before, 0)
        else
            found_indices = findall(isequal(last_spoken), spoken_before)
            i1, i2 = found_indices[(end - 1):end]
            push!(spoken_before, abs(i1 - i2))
        end
        
        if isequal(turn_number, n)
            return last(spoken_before)
        end
    end
end

println(nthnumberspoken(2020, parse_input(datafile)))

#=
BenchmarkTools.Trial:
  memory estimate:  3.04 MiB
  allocs estimate:  11566
  --------------
  minimum time:     3.162 ms (0.00% GC)
  median time:      3.612 ms (0.00% GC)
  mean time:        3.929 ms (4.25% GC)
  maximum time:     10.208 ms (0.00% GC)
  --------------
  samples:          1272
  evals/sample:     1
=#

"""
Since we always spoken the last
spoken number, the Dict is guaranteed to have a value.

If the first value of the tuple is 0, then it is a starting value and say 0;
otherwise, say the difference of values in that tuple. Then, update the
Dict for the spoken number with a new tuple.
"""
function nthnumberspoken_rethunk(n::Int, starting_numbers::Vector{Int})
    turn_number, spoken_before, last_spoken = length(starting_numbers), copy(starting_numbers), last(starting_numbers)
    n ≤ length(starting_numbers) && return starting_numbers[n]
    freq = Dict{Int, Int}(num => idx for (idx, num) in enumerate(starting_numbers[begin:(end - 1)]))

    while true
        local_last_spoken = turn_number - get(freq, last_spoken, turn_number)
        freq[last_spoken] = turn_number
        last_spoken = local_last_spoken

        if isequal(turn_number, n - 1)
            return last_spoken
        end

        turn_number += 1
    end
end

println(nthnumberspoken_rethunk(30000000, parse_input(datafile)))

#=
BenchmarkTools.Trial:
  memory estimate:  269.21 MiB
  allocs estimate:  112
  --------------
  minimum time:     2.221 s (3.12% GC)
  median time:      2.239 s (4.16% GC)
  mean time:        2.272 s (3.85% GC)
  maximum time:     2.356 s (3.95% GC)
  --------------
  samples:          3
  evals/sample:     1
=#
