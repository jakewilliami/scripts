const DATA_FILE = "data02.txt"

parse_input(f::String) = Pair{Char, Char}[line[1] => line[end] for line in readlines(f)]

@enum Play Rock=1 Paper Scissors
@enum Outcome Lose=0 Win=6 Draw=3

const COL1_MAP = Dict{Char, Play}('A' => Rock, 'B' => Paper, 'C' => Scissors)

# Part 1

const COL2_MAP_1 = Dict{Char, Play}('X' => Rock, 'Y' => Paper, 'Z' => Scissors)

parse_input_1(data::Vector{Pair{Char, Char}}) = Pair{Play, Play}[COL1_MAP[a] => COL2_MAP_1[b] for (a, b) in data]

# Does play b beat play a?
function wins(a::Play, b::Play)
    a == b && return Draw
    won = Play(mod1(Int(a) + 1, 3)) == b
    return won ? Win : Lose
end

play(input::Union{Vector{Pair{Play, Play}}, Vector{Pair{Play, Outcome}}}) =
    sum(Int(b) + Int(wins(a, b)) for (a, b) in input)


# Part 2

const COL2_MAP_2 = Dict{Char, Outcome}('X' => Lose, 'Y' => Draw, 'Z' => Win)

parse_input_2(data::Vector{Pair{Char, Char}}) = Pair{Play, Outcome}[COL1_MAP[a] => COL2_MAP_2[b] for (a, b) in data]

function wins(a::Play, b::Outcome)
    b == Draw && return a
    return Play(b == Win ? mod1(Int(a) + 1, 3) : mod1(Int(a) - 1, 3))
end


# Main

function main()
    raw_data = parse_input("data02.txt")

    # Part 1
    part1_data = parse_input_1(raw_data)
    part1_solution = play(part1_data)
    @assert part1_solution == 10595
    println("Part 1: $part1_solution")

    # Part 2
    part2_data = parse_input_2(raw_data)
    part2_solution = play(part2_data)
    @assert part2_solution == 9541
    println("Part 2: $part2_solution")
end

main()
