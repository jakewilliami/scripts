function count_yes(datafile::String)
    data = Vector{Int}()
    yes_counter = 0
    
    open(datafile) do io
        while ! eof(io)
            buffer = Vector{Char}()
            line = readline(io)
            
            while ! isempty(line)
                push!(buffer, collect(line)...)
                line = readline(io)
            end
            
            push!(data, length(unique(buffer)))
        end
    end
    
    return sum(data)
end
using BenchmarkTools
@benchmark (count_yes("data6.txt"))

#=
BenchmarkTools.Trial:
  memory estimate:  1.03 MiB
  allocs estimate:  12934
  --------------
  minimum time:     1.904 ms (0.00% GC)
  median time:      1.992 ms (0.00% GC)
  mean time:        2.165 ms (3.08% GC)
  maximum time:     7.280 ms (0.00% GC)
  --------------
  samples:          2309
  evals/sample:     1
=#

function flattenall(A::AbstractArray)
    while any(x -> typeof(x) <: AbstractArray, A)
        A = collect(Base.Iterators.flatten(A))
    end

    return A
end

deepunique(A::AbstractArray) = unique(flattenall(A))

function count_unanimous(datafile::String)
    data = Vector{Int}()
    yes_counter = 0

    open(datafile) do io
        while ! eof(io)
            buffer = Vector{Vector{Char}}()
            line = readline(io)

            while ! isempty(line)
                push!(buffer, collect(line))
                line = readline(io)
            end

            push!(data, length([i for i in deepunique(buffer) if all(x -> i ∈ x, buffer)]))
        end
    end

    return sum(data)
end

using BenchmarkTools
@benchmark (count_unanimous("data6.txt"))

#=
BenchmarkTools.Trial:
  memory estimate:  1.18 MiB
  allocs estimate:  15400
  --------------
  minimum time:     1.692 ms (0.00% GC)
  median time:      1.803 ms (0.00% GC)
  mean time:        1.929 ms (3.92% GC)
  maximum time:     5.670 ms (57.28% GC)
  --------------
  samples:          2591
  evals/sample:     1
=#
