function parse_range(r_str::S) where {S <: AbstractString}
    s1, s2 = split(r_str, '-')
    return parse(Int, s1):parse(Int, s2)
end

function parse_input(data_file::String)
    data = Tuple{UnitRange{Int}, UnitRange{Int}}[]
    for line in readlines(data_file)
        s1, s2 = split(line, ',')
        r1, r2 = parse_range(s1), parse_range(s2)
        push!(data, (r1, r2))
    end
    return data
end

function _solve_day_4(data::Vector{Tuple{UnitRange{Int}, UnitRange{Int}}}, f::Function)
    res = 0
    for (r1, r2) in data
        if f(i ∈ r2 for i in r1) || f(i ∈ r1 for i in r2)
            res += 1
        end
    end
    return res
end

part1(data::Vector{Tuple{UnitRange{Int}, UnitRange{Int}}}) =
    _solve_day_4(data, all)

part2(data::Vector{Tuple{UnitRange{Int}, UnitRange{Int}}}) =
    _solve_day_4(data, any)

function main()
    data = parse_input("data04.txt")

    # Part 1
    part1_solution = part1(data)
    @assert part1_solution == 538
    println("Part 1: $part1_solution")

    # Part 2
    part2_solution = part2(data)
    @assert part2_solution == 792
    println("Part 2: $part2_solution")
end

main()
