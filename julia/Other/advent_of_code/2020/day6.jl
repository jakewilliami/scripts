const datafile = "inputs/data6.txt"

function flattenall(A::AbstractArray)
    while any(x -> typeof(x) <: AbstractArray, A)
        A = collect(Base.Iterators.flatten(A))
    end

    return A
end

deepunique(A::AbstractArray) = unique(flattenall(A))

function count_yes(datafile::String)
    data = Vector{Int}()
    
    open(datafile) do io
        while ! eof(io)
            buffer = Vector{Vector{Char}}()
            line = readline(io)
            
            while ! isempty(line)
                push!(buffer, collect(line))
                line = readline(io)
            end
            
            push!(data, length(deepunique(buffer)))
        end
    end
    
    return sum(data)
end

println(count_yes(datafile))

#=
BenchmarkTools.Trial:
  memory estimate:  1.03 MiB
  allocs estimate:  12149
  --------------
  minimum time:     1.158 ms (0.00% GC)
  median time:      1.185 ms (0.00% GC)
  mean time:        1.303 ms (3.99% GC)
  maximum time:     7.399 ms (80.83% GC)
  --------------
  samples:          3834
  evals/sample:     1
=#

function count_unanimous(datafile::String)
    data = Vector{Int}()

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

println(count_unanimous(datafile))

#=
BenchmarkTools.Trial:
  memory estimate:  1.18 MiB
  allocs estimate:  15400
  --------------
  minimum time:     1.652 ms (0.00% GC)
  median time:      1.697 ms (0.00% GC)
  mean time:        1.843 ms (4.03% GC)
  maximum time:     6.418 ms (72.92% GC)
  --------------
  samples:          2712
  evals/sample:     1
=#
