const datafile = "inputs/data9.txt"

function get_pair_sum(preamble::Vector{T}, k::T) where T <: Number
    for i in preamble, j in preamble
        if i ≠ j && isequal(i + j, k)
            return i, j
        end
    end
    
    return nothing, nothing
end

function findfirst_invalid(datafile::String, preamble_length::Int)
    preamble = Vector{Int}()
    
    open(datafile) do io
        while ! eof(io)
            line = parse(Int, readline(io))
            
            push!(preamble, line)
            
            if isequal(length(preamble), preamble_length + 1)
                if all(isnothing.(get_pair_sum(preamble, line)))
                    return line
                end
                
                deleteat!(preamble, 1)
            end
        end
    end
end

println(findfirst_invalid(datafile, 25))

#=
BenchmarkTools.Trial:
  memory estimate:  23.00 KiB
  allocs estimate:  661
  --------------
  minimum time:     145.154 μs (0.00% GC)
  median time:      149.001 μs (0.00% GC)
  mean time:        166.677 μs (1.59% GC)
  maximum time:     6.101 ms (88.86% GC)
  --------------
  samples:          10000
  evals/sample:     1
=#

function get_contiguous_sum(data::Vector{T}, k::T) where T <: Number
    for starting_idx in 1:length(data)
        starting_point, sum_span = getindex(data, starting_idx), 1

        while sum_span ≤ length(data) - starting_idx
            if isequal(sum([getindex(data, i) for i in starting_idx:(starting_idx + sum_span)]), k)
                return getindex(data, starting_idx:(starting_idx + sum_span))
            end

            sum_span += 1
        end
    end

    return nothing
end

function get_encryption_weakness(datafile::String, preamble_length::Int)
    preamble = Vector{Int}()
    data = parse.(Int, readlines(datafile))

    for line in data
        push!(preamble, line)

        if isequal(length(preamble), preamble_length + 1)
            if all(isnothing.(get_pair_sum(preamble, line)))
                return sum(extrema(get_contiguous_sum(data, line)))
            end

            deleteat!(preamble, 1)
        end
    end
end ==

println(get_encryption_weakness(datafile, 25))

#=
BenchmarkTools.Trial:
  memory estimate:  1.16 GiB
  allocs estimate:  388972
  --------------
  minimum time:     333.684 ms (32.55% GC)
  median time:      342.555 ms (33.44% GC)
  mean time:        352.691 ms (33.49% GC)
  maximum time:     424.680 ms (36.92% GC)
  --------------
  samples:          15
  evals/sample:     1
=#
