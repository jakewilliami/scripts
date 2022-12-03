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


# Main (Linear Algebra)

# reddit.com/r/adventofcode/comments/zac2v2/2022_day_2_solutions/iynysrx
#
# While this solution is really cool, it is not as efficient; 979.906 μs
# (12500 allocations: 429.69 KiB), compared to 6.245 μs (0 allocations: 0 bytes).
# I implemented part 1 using this anyway as I saw it on Reddit and thought
# it was cool.

using LinearAlgebra

function main_lin_alg()
    ROCK_BASIS, PAPER_BASIS, SCISSORS_BASIS  = eachcol(I(3))

    RPC_M = [3  0  6
             6  3  0
             0  6  3]

    RPC_BASES = Dict{Play, AbstractVector}(
        Rock => ROCK_BASIS,
        Paper => PAPER_BASIS,
        Scissors => SCISSORS_BASIS
    )

    play_lin_alg(a::Play, b::Play) =
        Outcome(transpose(RPC_BASES[b]) * RPC_M * RPC_BASES[a])
    play_lin_alg(input::Vector{Pair{Play, Play}}) =
        sum(Int(b) + Int(play_lin_alg(a, b)) for (a, b) in input)


    raw_data = parse_input("data02.txt")

    part1_data = parse_input_1(raw_data)
    part1_solution = play_lin_alg(part1_data)
    @assert part1_solution == 10595
    println("Part 1 (using Linear Algebra): $part1_solution")
end
