parse_input(data_file::String) =
    String[line for line in readlines(data_file)]

function priority(c::Char)
    if 'a' ≤ c ≤ 'z'
        return c - 'a' + 1
    elseif 'A' ≤ c ≤ 'Z'
        return c - 'A' + 26 + 1
    end
    error("Undefined priority for character $(repr(c))")
end


# Part 1

function part1(data::Vector{String})
    res = 0
    for r in data
        m = length(r) ÷ 2
        a, b = r[1:m], r[(m + 1):end]
        for c in a ∩ b
            res += priority(c)
        end
    end
    return res
end


# Part 2

function part2(data::Vector{String})
    res = 0
    for (a, b, c) in Base.Iterators.partition(data, 3)
        common = only(a ∩ b ∩ c)
        res += priority(common)
    end
    return res
end


# Main

function main()
    data = parse_input("data03.txt")

    # Part 1
    part1_solution = part1(data)
    @assert part1_solution == 8053
    println("Part 1: $part1_solution")

    # Part 2
    part2_solution = part2(data)
    @assert part2_solution == 2425
    println("Part 2: $part2_solution")
end

main()
