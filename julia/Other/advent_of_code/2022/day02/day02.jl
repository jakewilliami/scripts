const DATA_FILE = "data02.txt"

parse_input(f::String) = Pair{Char, Char}[line[1] => line[end] for line in readlines(f)]


# Part 1

@enum Play Rock=1 Paper=2 Scissors=3

const COL1_MAP = Dict{Char, Play}('A' => Rock, 'B' => Paper, 'C' => Scissors)
const COL2_MAP_1 = Dict{Char, Play}('X' => Rock, 'Y' => Paper, 'Z' => Scissors)

parse_input_1(data::Vector{Pair{Char, Char}}) = Pair{Play, Play}[COL1_MAP[a] => COL2_MAP_1[b] for (a, b) in data]

function wins(a::Play, b::Play)
    a == b && return 2
    v = [Paper, Scissors, Rock]
    if (a == Rock && b == Paper)
        return 1
    elseif a == Rock && b == Scissors
        return 0
    elseif a == Paper && b == Scissors
        return 1
    elseif a == Scissors && b == Paper
        return 0
    elseif a == Paper && b == Rock
        return 0
    elseif a == Scissors && b == Rock
        return 1
    elseif a == Rock && b == Paper
        return 0
    elseif a == b
        return 2
    end
    error("unreachable: $a, $b")
end

function play(input::Vector{Pair{Play, Play}})
    res = 0
    for i in input
        w = wins(i...)
        res += iszero(w) ? 0 : Int(6 / w)
        res += Int(i[2])
    end
    return res
end


# Part 2

@enum Outcome Lose=0 Win=6 Draw=3

const COL2_MAP_2 = Dict{Char, Outcome}('X' => Lose, 'Y' => Draw, 'Z' => Win)

parse_input_2(data::Vector{Pair{Char, Char}}) = Pair{Play, Outcome}[COL1_MAP[a] => COL2_MAP_2[b] for (a, b) in data]

function wins(a::Play, b::Outcome)
    v = [Paper, Scissors, Rock]
    v′ = circshift(v, -1)
    i = Int(a)
    if b == Win
        return v[i]
    elseif b == Lose
        return v′[i]
    elseif b == Draw
        return a
    end
    error("unreachable: $a, $b")
end

function play(input::Vector{Pair{Play, Outcome}})
    res = 0
    for i in input
        res += Int(wins(i...))
        res += Int(i[2])
    end
    return res
end


# Main

function main()
    # 1 = 10595
    # 2 = 9541

    raw_data = parse_input("data02.txt")

    # Part 1
    part1_data = parse_input_1(raw_data)
    part1_solution = play(part1_data)
    println("Part 1: $part1_solution")

    # Part 2
    part2_data = parse_input_2(raw_data)
    part2_solution = play(part2_data)
    println("Part 2: $part2_solution")
end

main()
