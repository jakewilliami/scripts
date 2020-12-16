using DelimitedFiles: readdlm

const datafile = joinpath(@__DIR__, "inputs", "data13.txt")

function parse_input(datafile::String)
    data = readdlm(datafile, ',')
    return data[1, 1], data[2, :]
end

function catch_nearest_bus(input::NTuple{2, Any})
    earliest_timestamp, IDs = input
    viable_options = NTuple{2, Int}[(ID, ID * cld(earliest_timestamp, ID)) for ID in IDs if ID ≠ "x"]
    earliest_bus_id, earliest_bus_timestamp = first(view(viable_options, argmin(Int[x for (_, x) in viable_options])))
    
    return (earliest_bus_timestamp - earliest_timestamp) * earliest_bus_id
end

println(catch_nearest_bus(parse_input(datafile)))

#=
BenchmarkTools.Trial:
memory estimate:  68.81 KiB
allocs estimate:  523
--------------
minimum time:     117.912 μs (0.00% GC)
median time:      124.746 μs (0.00% GC)
mean time:        146.846 μs (5.77% GC)
maximum time:     9.457 ms (74.27% GC)
--------------
samples:          10000
evals/sample:     1
=#

function find_timestamp_brute_force_old(input::NTuple{2, Any})
    _, IDs = input
    data = NTuple{2, Int}[(ID, ID_idx - 1) for (ID_idx, ID) in enumerate(IDs) if ID ≠ "x"]
    IDs = Int[ID for (ID, ID_idx) in data]
    first_ID, t = first(IDs), ifelse(last(last(data)) > 7, 100000000000000, 0) # the problem suggest that our input (much larger than the test input) will easily be at least 100000000000000

    while true
        timestamps = NTuple{2, Int}[(ID, t + consec_shift) for (ID, consec_shift) in data]
        departures = Int[ID * cld(timestamp, ID) for (ID, timestamp) in timestamps]
        if isequal(Int[timestamp for (ID, timestamp) in timestamps], departures)
            return t
        else
            t += first_ID
        end
    end

    return nothing
end

# println(find_timestamp_brute_force_old(parse_input(datafile))) # may take months to finish

@inline function findfirstdiscrepancy(A::Vector{T}, B::Vector{T}) where T
    if A === B return nothing end

    if length(A) != length(B)
        error("Arrays not the same length.")
    end

    for (idx, row) in enumerate(zip(A, B))
        a, b = row
        if ! isequal(a, b)
            return idx
        end
    end

    return nothing
end

function find_timestamp_brute_force(input::NTuple{2, Any})
    _, IDs = input
    data = NTuple{2, Int}[(ID, ID_idx - 1) for (ID_idx, ID) in enumerate(IDs) if ID ≠ "x"]
    IDs = Int[ID for (ID, _) in data]
    first_ID, t = first(IDs), ifelse(last(last(data)) > 7, 100000000000000, 0) # the problem suggest that our input (much larger than the test input) will easily be at least 100000000000000

    while true
        timestamps = NTuple{2, Int}[(ID, t + consec_shift) for (ID, consec_shift) in data]
        departures = Int[ID * cld(timestamp, ID) for (ID, timestamp) in timestamps]
        discrepancy = findfirstdiscrepancy(Int[timestamp for (_, timestamp) in timestamps], departures)

        if isnothing(discrepancy)
            return t
        else
            t += prod(view(IDs, 1:(discrepancy - 1)))
        end
    end

    return nothing
end

println(find_timestamp_brute_force(parse_input(datafile)))

#=
BenchmarkTools.Trial:
  memory estimate:  616.14 KiB
  allocs estimate:  3772
  --------------
  minimum time:     350.926 μs (0.00% GC)
  median time:      361.290 μs (0.00% GC)
  mean time:        405.002 μs (3.35% GC)
  maximum time:     3.548 ms (65.16% GC)
  --------------
  samples:          10000
  evals/sample:     1
=#

using Mods: CRT, Mod, modulus

function find_timestamp_clever(input::NTuple{2, Any})
    rubbish, IDs = input
    mods = Mod[Mod(ID_idx - 1, ID) for (ID_idx, ID) in enumerate(IDs) if ID ≠ "x"]
    res = reduce(CRT, mods)

    return modulus(res) - res.val
end
using BenchmarkTools
@benchmark (find_timestamp_clever(parse_input(datafile)))

#=
BenchmarkTools.Trial:
  memory estimate:  78.14 KiB
  allocs estimate:  744
  --------------
  minimum time:     120.705 μs (0.00% GC)
  median time:      132.550 μs (0.00% GC)
  mean time:        176.070 μs (6.00% GC)
  maximum time:     24.057 ms (87.24% GC)
  --------------
  samples:          10000
  evals/sample:     1
=#
