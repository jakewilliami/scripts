parse_input(data_file::String) =
    [line for line in readlines("data03.txt")]

priority(c::Char) = 'a' ≤ c ≤ 'z' ? Int(c) - 96 : Int(c) - 64 + 26


# Part 1

function common_items(a, b)
    v = []
    for c in a
        if c ∈ b
            push!(v, c)
        end
    end
    return unique(v)
end

function part1(data::Vector{String})
    res = 0
    for r in data
        a, b = r[1:(length(r) ÷ 2)], r[((length(r) ÷ 2) + 1):end]
        v = common_items(a, b)
        for c in v
            res += priority(c)
        end
    end
    return res
end


# Part 2

function common_badge(v)
    for i in 1:length(v)
        for c in v[i]
            if c ∈ v[mod1(i + 1, 3)] && c ∈ v[mod1(i + 2, 3)]
                return c
            end
        end
    end
end

function part2(data::Vector{String})
    res = 0
    for v in Base.Iterators.partition(data, 3)
        res += priority(common_badge(v))
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
