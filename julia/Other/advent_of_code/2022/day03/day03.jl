parse_input(data_file::String) =
    String[line for line in readlines(data_file)]

function priority(c::Char)
    if 'a' ≤ c ≤ 'z'
        return Int(c) - 96
    elseif 'A' ≤ c ≤ 'Z'
        return Int(c) - 64 + 26
    end
    error("unreachable: $c")
end


# Part 1

function part1(data::Vector{String})
    res = 0
    for r in data
        a, b = r[1:(length(r) ÷ 2)], r[((length(r) ÷ 2) + 1):end]
        v = intersect(a, b)
        for c in v
            res += priority(c)
        end
    end
    return res
end


# Part 2

function part2(data::Vector{String})
    res = 0
    for v in Base.Iterators.partition(data, 3)
        common = only(intersect(v...))
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
