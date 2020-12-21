using DelimitedFiles: readdlm

const datafile = joinpath(@__DIR__, "inputs", "data14.txt")

function pushto!(V::Vector{T}, val::T, i::Int) where T <: Number
    if i > length(V)
        [push!(V, zero(T)) for _ in (length(V) + 1):(i - 1)]
        push!(V, val)
    else
        V[i] = val
    end
    
    return V
end

function apply_mask(mem::Int, mask::AbstractString)
    A, mask = collect(bitstring(mem)[end-35:end]), collect(mask)
    i = findall(!isequal('X'), mask)
    A[i] .= mask[i]
    
    return parse(Int, join(A), base = 2)
end

function part1(datafile::String)
    out = Dict{Int, Int}()
    mask = string()

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

println(part1(datafile))

# using Combinatorics
#
# function part2(input_file::String)
#     storage = Dict()
#
#     for line in eachline(input_file)
#         line[1:4] == "mask" && (global mask = line[8:end]) != 0 && continue
#         store = SubString.(line, findall(r"\d+", line))
#         masked = parse(Int, store[1]) | parse(Int, replace(mask, 'X' => '0'), base=2)
#         masked &= parse(Int, replace(replace(mask, '0' => '1'), 'X' => '0'), base=2)
#         possible = powerset(findall(x -> x == 'X', mask))
#
#         for mas in possible
#             num = masked | parse(Int, join([(bit ∈ mas ? '1' : '0') for bit in 1:36]), base=2)
#             storage[num] = parse(Int, store[2])
#         end
#     end
#
#     return sum(values(storage))
# end
#
# println(part2("inputs/test.txt"))
