using DelimitedFiles: readdlm

const datafile = joinpath(@__DIR__, "inputs", "data14.txt")

function apply_mask!(mask, mem::Vector{Int})
    mask = tryparse.(Int, string.(collect(mask)))
    
    for (idx, val) in enumerate(mask)
        val ≠ nothing && setindex!(mem, val, idx)
    end
    
    return mem
end

apply_mask(mask::Vector{Int}, mem::Vector{Int}) = apply_mask!(copy(mask), mem)

function part1(datafile::String)
    mem, mask = Vector{Int}(undef, 36), Vector{Int}(undef, 36)
    # mem, mask = zeros(Int, 36), zeros(Int, 36)
    # mem, mask = string(), string()

    open(datafile) do io
        while ! eof(io)
            identifier, value = split(readline(io), " = ")
            line = readline(io)
            
            if identifier == "mask"
                # apply_mask!(mask, mem)
                mask = parse.(Int, replace(value, 'X' => '0'), base = 2)
                # mask = parse.(Int, string.(collect(string(parse(Int, identifier), base = 2))))
                # mask = parse.(Int, string.(collect(value)), base = 2)
                # continue
            else
                # local_mem = Vector{Int}(undef, 36)
                # local_mem = zeros(Int, 36)
                # mem = parse.(Int, string.(collect(string(parse(Int, match(r"\d", identifier).match), base = 2))))
                # mem = parse.(Int, string.(collect(match(r"\d", identifier).match)), base = 2)
                println(mem)
                # println(mem_addr)
                # mem_slot = parse(Int, value)
                # local_mem[(36 - length(mem_addr) + 1):end] .= mem_addr
                # println("Applying mask to $local_mem")
                # println(SubString.(line, findall(r"\d+", line)))
                # println(parse(Int, match(r"\d", identifier).match))
                # println(parse(Int, value, base = 2))
                # println("hello")
                # apply_mask!(local_mem, mask)
                # mem = local_mem
                # println("mask applied: $mem")
            end
        end
    end
    
    return mem
    return parse(Int, join(mem), base = 10)
end

println(part1("inputs/test.txt"))

function part1(input_file::String)
    storage = Dict()

    for line in eachline(input_file)
        line[1:4] == "mask" && (global mask = line[8:end]) != 0 && continue
        store = SubString.(line, findall(r"\d+", line))
        # println(store)
        masked = parse(Int, store[2]) | parse(Int, replace(mask, 'X' => '0'), base = 2)
        masked &= parse(Int, replace(mask, 'X' => '1'), base = 2)
        storage[store[1]] = masked
        println(storage)
    end

    return sum(values(storage))
end

# println(part1("inputs/test.txt"))

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
