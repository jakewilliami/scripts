const datafile = "inputs/data10.txt"

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

function count_adaptor_permutations(joltages::Vector{Int})
    sorted = sort(joltages)
    difference, permutation_count, local_comb_map = vcat(1, sorted[2:end] - sorted[1:end-1], 3), 1, [1, 1, 2, 4, 7]

    i = 1
    while i ≤ length(difference) - 1
        j = findnext(x -> x == 3, difference, i)
        n = j - i

        if 0 ≤ n ≤ 4
            local_count = local_comb_map[n+1]
        else
            local_count =  reduce(+, [binomial(n - 1, k) for k in 0:n-1]) - (((n-3)(n-2)) / 2, 0)
        end

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
