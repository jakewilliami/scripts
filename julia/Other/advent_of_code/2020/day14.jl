using DelimitedFiles: readdlm

const datafile = joinpath(@__DIR__, "inputs", "data14.txt")

function apply_mask!(mask::Vector{Int}, mem::Vector{Int})
    for (idx, val) in enumerate(mask)
        isone(val) && setindex!(mem, val, idx)
    end
    
    return mem
end

apply_mask(mask::Vector{Int}, mem::Vector{Int}) = apply_mask!(copy(mask), mem)

function part1(datafile::String)
    mem, mask = zeros(Int, 36), zeros(Int, 36)
    # out = Vector{Int}()
    out = Vector{Int}(undef, 1_000_000)

    open(datafile) do io
        while ! eof(io)
            identifier, value = split(readline(io), " = ")
            
            if identifier == "mask"
                mask = parse.(Int, string.(collect(replace(value, 'X' => '0'))))
            else
                local_mem = zeros(Int, 36)
                mem_addr = parse(Int, match(r"\d", identifier).match)
                value = parse.(Int, collect(string(parse(Int, value), base = 2)))
                local_mem[(36 - length(value) + 1):end] .= value
                apply_mask!(mask, local_mem)
                val = parse(Int, join(local_mem), base = 2)
                out[mem_addr] = val
            end
        end
    end
    
    return sum(out)
end

println(part1(datafile))

function part1(input_file::String)
    storage = Dict()

    for line in eachline(input_file)
        line[1:4] == "mask" && (global mask = line[8:end]) != 0 && continue
        store = SubString.(line, findall(r"\d+", line))
        masked = parse(Int, store[2]) | parse(Int, replace(mask, 'X' => '0'), base = 2)
        masked &= parse(Int, replace(mask, 'X' => '1'), base = 2)
        storage[store[1]] = masked
    end

    return sum(values(storage))
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
