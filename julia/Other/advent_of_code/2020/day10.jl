const datafile = joinpath(@__DIR__, "inputs", "data10.txt")

load_file(datafile::String) = parse.(Int, readlines(datafile))

function get_adaptors_and_differences(joltages::Vector{Int})
    chosen_adaptors = Matrix{Int}(undef, 0, 2)
    builtin, current_adaptor = maximum(joltages) + 3, 0
    
    while true
        current_options = filter(e -> e ≤ current_adaptor + 3, joltages)
        new_adaptor = minimum(current_options)
        difference = new_adaptor - current_adaptor
        current_adaptor = new_adaptor
        deleteat!(joltages, findfirst(e -> e == current_adaptor, joltages))
        chosen_adaptors = cat(chosen_adaptors, [new_adaptor difference], dims = 1)
        
        if current_adaptor == builtin - 3
            chosen_adaptors = cat(chosen_adaptors, [builtin 3], dims = 1)
            
            return chosen_adaptors
        end
    end
end

function count_adaptor_differences(datafile::String)
    differences = get_adaptors_and_differences(load_file(datafile))[:, 2]
    return Tuple(count(==(i), differences) for i in unique(differences))
end

println(prod(count_adaptor_differences(datafile)))

#=
BenchmarkTools.Trial:
  memory estimate:  293.77 KiB
  allocs estimate:  4033
  --------------
  minimum time:     790.140 μs (0.00% GC)
  median time:      891.369 μs (0.00% GC)
  mean time:        977.456 μs (1.93% GC)
  maximum time:     5.319 ms (81.22% GC)
  --------------
  samples:          5108
  evals/sample:     1
=#

"""
The number of combinations for varying n:

When there are n consecutive 1's, we can't remove the last adapter, otherwise
the step will be larger than three. But we can remove each of the first n-1
adapters. We can also change any two of the first n-1 adapters. Finally,
if n is greater than 4, we can also change any three to n-1 adapters provided
there aren't more than two consecutive removals. So, that is what we can do
    1 option of not removing anything (i.e. n-1 choose 0 options)
    n-1 choose 1 options of removing exactly one of the first n-1 adapters
    n-1 choose 2 options of removing exactly two of the first n-1 adapters
    n-1 choose 3 options of removing exactly three of the first n-1 adapters,
        discounting all the consecutive choices. The number of consecutive
        choices can be found by counting where they start. They can start at
        the first position, then at the second, up to the n-3 position, since
        we can change the last one. Hence, we can change n-3 adapters
    n-1 choose k options of removing exactly k of the first n-1 adapters,
        discounting all the n-k consecutive choices of k adapters.
        1+2+⋯+n-3, which is
        an arithmetic progression that sum up to (n-3)(1+n-3)/2 = (n-2)(n-3)/2
    ...
    n-1 choose n-1 options of removing exactly n-1 of the first n-1 adapters,
        discounting 1 consecutive choice of n-1 options, which is thus
        n = 0, 1, 2 and 3, if n-1 ≥ 3, and is zero if n ≥ 4.
Hence, the general form is
    local_comb = sum([binomial(n-1,k) for k in 0:n-1]) - sum([n-k for k in 3:n-1])
        = sum([binomial(n-1,k) for k in 0:n-1]) - (1 + 2 + 3 + ⋯ + n - 3)
        = sum([binomial(n-1,k) for k in 0:n-1]) - (n-3)(n-2)/2
        where the last term is present only if n ≥ 4
Besides, since lower values of n should be more frequent, it is faster if we
just calculate some of them before hand, e.g. for n = 0, 1, 2, 3, 4:
    n = 0 or 1 => local_comb = 1
    n = 2 => local_comb = 2
    n = 3 => local_comb = 4
    n = 4 => local_comb = 7
    n ≥ 5 => local_comb = sum([binomial(n-1,k) for k in 0:n-1]) - (n-3)(n-2)/2
That gives me
```julia
julia> @btime num_connections(list)
  15.115 μs (45 allocations: 8.52 KiB)
```
"""
function count_adaptor_permutations(joltages::Vector{Int})
    sorted = sort(joltages)
    difference, permutation_count, local_comb_map = vcat(1, sorted[2:end] - sorted[1:end-1], 3), 1, [1, 1, 2, 4, 7]

    i = 1
    while i ≤ length(difference) - 1
        j = findnext(x -> x == 3, difference, i)
        n = j - i
        local_count = 0 ≤ n ≤ 4 ? local_comb_map[n+1] : reduce(+, [binomial(n - 1, k) for k in 0:n-1]) - (((n-3)(n-2)) / 2)
        i = j + 1
        permutation_count *= local_count
    end

    return permutation_count
end

function count_adaptor_permutations(datafile::String)
    joltages = load_file(datafile)
    return count_adaptor_permutations(joltages)
end

println(count_adaptor_permutations(datafile))

#=
2244
BenchmarkTools.Trial:
  memory estimate:  13.80 KiB
  allocs estimate:  245
  --------------
  minimum time:     32.209 μs (0.00% GC)
  median time:      33.312 μs (0.00% GC)
  mean time:        37.124 μs (4.07% GC)
  maximum time:     6.157 ms (83.71% GC)
  --------------
  samples:          10000
  evals/sample:     1
=#
