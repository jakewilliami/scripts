parse_input(input_file::String) =
    [[parse(Int, i) for i in split(s)] for s in split(read(input_file, String), "\n\n")]

part1(data::Vector{Vector{Int}}) =
    maximum(sum(d) for d in data)

part2(data::Vector{Vector{Int}}) =
    sum(sort([sum(d) for d in data], rev=true)[1:3])

function main()
    data = parse_input("data1.txt")

    # Part 1
    part1_solution = part1(data)
    println("Part 1: $part1_solution")

    # Part 2
    part2_solution = part2(data)
    println("Part 2: $part2_solution")
end

main()
