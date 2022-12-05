# Parse input

const Crate = Char
const CrateState = Vector{Vector{Crate}}

struct Instruction
    n::Int
    src::Int
    dest::Int
end

INIT_CRATE_STATE_REGEXP = r"\s*\[([a-zA-Z]+)\]\s*"
INSTRUCTION_REGEXP = r"move (\d+) from (\d+) to (\d+)"

function parse_input(data_file::String)
    data_raw = read(data_file, String)
    A, B = split(data_raw, "\n\n")

    # Parse initial state
    col_width = 4
    init_state = Vector{Char}[Char[] for _ in 1:cld((findfirst('\n', A) - 1), col_width)]
    for a in split(A, "\n")
        for (i, b) in enumerate(Base.Iterators.partition(a, col_width))
            m = match(INIT_CRATE_STATE_REGEXP, join(b))
            isnothing(m) && continue
            b = only(m.captures)
            push!(init_state[i], only(b))
        end
    end

    # Parse instructions
    instructions = Instruction[]
    for b in split(B, "\n")
        isempty(strip(b)) && continue
        m = match(INSTRUCTION_REGEXP, b)
        n, src, dest = m.captures
        i = Instruction(parse(Int, n), parse(Int, src), parse(Int, dest))
        push!(instructions, i)
    end

    return init_state, instructions
end


# Part 1

function cratemover_9000(init_state::CrateState, instructions::Vector{Instruction})
    state = deepcopy(init_state)
    for inst in instructions
        for _ in 1:inst.n
            q = popfirst!(state[inst.src])
            pushfirst!(state[inst.dest], q)
        end
    end
    return state
end

read_top_crates(state::CrateState) = join(first(c) for c in state)

function part1(init_state::CrateState, instructions::Vector{Instruction})
    new_state = cratemover_9000(init_state, instructions)
    return read_top_crates(new_state)
end


# Part 2

function cratemover_9001(init_state::CrateState, instructions::Vector{Instruction})
    state = deepcopy(init_state)
    for inst in instructions
        d = Crate[]
        for _ in 1:inst.n
            q = popfirst!(state[inst.src])
            push!(d, q)
        end
        prepend!(state[inst.dest], d)
    end
    return state
end

function part2(init_state::CrateState, instructions::Vector{Instruction})
    new_state = cratemover_9001(init_state, instructions)
    return read_top_crates(new_state)
end


# Main

function main()
    init_state, instructions = parse_input("data05.txt")

    # Part 1
    part1_solution = part1(init_state, instructions)
    @assert part1_solution == "FWSHSPJWM"
    println("Part 1: $part1_solution")

    # Part 2
    part2_solution = part2(init_state, instructions)
    @assert part2_solution == "PWPWHGFZS"
    println("Part 2: $part2_solution")
end

main()
