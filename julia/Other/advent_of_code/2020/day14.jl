using DelimitedFiles: readdlm

const datafile = joinpath(@__DIR__, "inputs", "data14.txt")

function findunchanged(A::Union{Vector{Char}, AbstractString})
    indices = Vector{Int}()

    for (idx, val) in enumerate(A)
        isequal(val, 'X') || push!(indices, idx)
    end

    return indices
end

function apply_mask(mem::Int, mask::AbstractString)
    A, mask = collect(bitstring(mem)[(end - 35):end]), collect(mask)
    i = findunchanged(mask)
    A[i] .= mask[i]
    
    return parse(Int, join(A), base = 2)
end

function sum_masked_values(datafile::String)
    out, mask = Dict{Int, Int}(), string()

    open(datafile) do io
        while ! eof(io)
            identifier, value = split(readline(io), " = ")
            
            if identifier == "mask"
                mask = value
            else
                mem_addr = parse(Int, match(r"\d+", identifier).match)
                val = parse(Int, value)
                out[mem_addr] = apply_mask(val, mask)
            end
        end
    end
    
    return sum(values(out))
end

println(sum_masked_values(datafile))

#=
BenchmarkTools.Trial:
  memory estimate:  1.33 MiB
  allocs estimate:  16108
  --------------
  minimum time:     1.768 ms (0.00% GC)
  median time:      2.046 ms (0.00% GC)
  mean time:        2.274 ms (3.56% GC)
  maximum time:     7.522 ms (41.93% GC)
  --------------
  samples:          2198
  evals/sample:     1
=#

function unfold(A::Union{AbstractArray, Tuple})
    while any(x -> typeof(x) <: Union{AbstractArray, Tuple}, A)
        A = collect(Base.Iterators.flatten(A))
    end

    return A
end

function findfloating(A::Union{Vector{Char}, AbstractString})
    indices = Vector{Int}()

    for (idx, val) in enumerate(A)
        isequal(val, 'X') && push!(indices, idx)
    end

    return indices
end

function get_combinations(A::Vector{Char})
    out, B = Vector{String}(), findfloating(A)

    # for t in unfold.(reduce(Base.Iterators.product, [['0', '1'] for _ in 1:length(B)]))
    for t in Base.Iterators.product(Vector{Char}[['0', '1'] for _ in 1:length(B)]...)
    # for t in reduce(Base.Iterators.product, Base.Iterators.repeated(['0', '1'], length(B)))
    # for t in Base.Iterators.product(Base.Iterators.repeated(['0', '1'], length(B))...)
        local_A = copy(A)
        local_A[B] .= t
        push!(out, join(local_A))
    end

    return parse.(Int, out, base = 2)
end

function apply_mask_v2(mem::Int, mask::AbstractString)
    A = collect(bitstring(mem)[(end - 35):end])

    for (i, char) in enumerate(mask)
        char ≠ '0' && (A[i] = char)
    end

    return A
end

function get_possible_values(mem::Int, mask::AbstractString)
    return get_combinations(apply_mask_v2(mem, mask))
end

function sum_values_remaining(datafile::String)
    out, mask = Dict{Int, Int}(), string()

    open(datafile) do io
        while ! eof(io)
            identifier, value = split(readline(io), " = ")

            if identifier == "mask"
                mask = value
            else
                mem_addr = parse(Int, match(r"\d+", identifier).match)
                key = parse(Int, value)

                for m in get_possible_values(mem_addr, mask)
                    out[m] = key
                end
            end
        end
    end

    return sum(values(out))
end

println(sum_values_remaining(datafile))

#=
BenchmarkTools.Trial:
  memory estimate:  102.41 MiB
  allocs estimate:  1227851
  --------------
  minimum time:     267.388 ms (3.03% GC)
  median time:      281.606 ms (3.19% GC)
  mean time:        299.399 ms (6.72% GC)
  maximum time:     530.904 ms (35.58% GC)
  --------------
  samples:          17
  evals/sample:     1
=#
