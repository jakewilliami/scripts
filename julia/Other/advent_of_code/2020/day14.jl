using DelimitedFiles: readdlm

const datafile = joinpath(@__DIR__, "inputs", "data14.txt")

function apply_mask(mem::Int, mask::AbstractString)
    A, mask = collect(bitstring(mem)[(end - 35):end]), collect(mask)
    i = findall(!isequal('X'), mask)
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
  memory estimate:  1.37 MiB
  allocs estimate:  16580
  --------------
  minimum time:     1.883 ms (0.00% GC)
  median time:      2.397 ms (0.00% GC)
  mean time:        3.276 ms (5.20% GC)
  maximum time:     66.226 ms (0.00% GC)
  --------------
  samples:          1524
  evals/sample:     1
=#

function unfold(A::Union{AbstractArray, Tuple})
    while any(x -> typeof(x) <: Union{AbstractArray, Tuple}, A)
        A = collect(Base.Iterators.flatten(A))
    end

    return A
end

function get_combinations(A::Vector{Char})
    out = Vector{String}()

    for t in (unfold.(reduce(Base.Iterators.product, [['0', '1'] for _ in 1:count(isequal('X'), A)])))
        local_A = copy(A)
        local_A[findall(isequal('X'), A)] .= t
        push!(out, join(local_A))
    end

    return parse.(Int, out, base = 2)
end

function get_combinations(A::AbstractString)
    A, out = A isa AbstractString ? collect(A) : A, Vector{String}()

    return get_combinations(A)
end

function apply_mask_v2(mem::Int, mask::AbstractString)
    A, mask, out = collect(bitstring(mem)[(end - 35):end]), collect(mask), Vector{String}()
    [setindex!(A, char, i) for (i, char) in enumerate(mask) if char ≠ '0']

    return A
end

function get_possible_values(mem::Int, mask::Union{AbstractString, Vector{String}})
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
                M = get_possible_values(mem_addr, mask)
                key = parse(Int, value)

                for m in M
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
  memory estimate:  751.30 MiB
  allocs estimate:  19955461
  --------------
  minimum time:     4.454 s (2.07% GC)
  median time:      4.491 s (2.01% GC)
  mean time:        4.491 s (2.01% GC)
  maximum time:     4.528 s (1.95% GC)
  --------------
  samples:          2
  evals/sample:     1
=#
