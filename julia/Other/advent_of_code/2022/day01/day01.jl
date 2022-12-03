parse_input(input_file::String) =
    [[parse(Int, i) for i in split(s)] for s in split(read(input_file, String), "\n\n")]

part1(data::Vector{Vector{Int}}) =
    maximum(sum(d) for d in data)

part2(data::Vector{Vector{Int}}) =
    sum(sort([sum(d) for d in data], rev=true)[1:3])

function main()
    data = parse_input("data01.txt")

    # Part 1
    part1_solution = part1(data)
    @assert part1_solution == 69289
    println("Part 1: $part1_solution")

    # Part 2
    part2_solution = part2(data)
    @assert part2_solution == 205615
    println("Part 2: $part2_solution")
end

main()
